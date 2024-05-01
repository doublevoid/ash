defmodule AshWeb.Components.CommentComponent do
  use AshWeb, :live_component

  def render(assigns) do
    assigns =
      assign(assigns, :local_root_comment, assigns[:root_comment] || assigns.comment)
      |> assign(:child_comments_count, Enum.count(assigns.comment.child_comments))

    ~H"""
    <div class="flex flex-col">
      <div class="flex flex-row text-sm">
        <.link patch={~p"/u/#{@comment.user.username}"} class="mr-1">
          /u/<%= @comment.user.username %>
        </.link>
        <p>
          at: <%= @comment.inserted_at %>
        </p>
      </div>
      <div>
        <p>
          <%= @comment.body %>
        </p>
        <div class="flex flex-row gap-2">
          <button phx-click={JS.show(to: "#reply-comment-#{@comment.id}")}>
            reply
          </button>
          <button
            :if={@comment.reply_count > 0 && @child_comments_count != @comment.reply_count}
            class="text-xs"
            phx-click="load-replies"
            value={@local_root_comment.id}
          >
            <%= "load (#{@comment.reply_count - @child_comments_count}) replies" %>
          </button>
        </div>
      </div>
      <div id={"reply-comment-#{@comment.id}"} class="hidden">
        <.live_component
          :if={@current_user}
          module={AshWeb.CommentLive.FormComponent}
          id={"comment-new-child-#{@comment.id}"}
          comment={%Ash.Discussions.Comment{}}
          action={:new}
          post_id={@comment.post_id}
          user={@current_user}
          parent_comment_id={@comment.id}
          root_comment={@local_root_comment}
          patch={~p"/c/#{@post.community.name}/comments/#{@comment.post_id}"}
        />
      </div>
      <div :for={comment <- @comment.child_comments} class="flex flex-row">
        <.live_component
          module={AshWeb.Components.VoteComponent}
          id={"vote-comment-#{comment.id}"}
          current_user={@current_user}
          voteable={comment}
        />
        <.live_component
          module={AshWeb.Components.CommentComponent}
          id={"comment-#{comment.id}"}
          current_user={@current_user}
          comment={comment}
          post={@post}
          root_comment={@local_root_comment}
        />
      </div>
    </div>
    """
  end
end

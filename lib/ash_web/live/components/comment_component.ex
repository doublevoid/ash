defmodule AshWeb.Components.CommentComponent do
  use AshWeb, :live_component

  def render(assigns) do
    root_comment_id = assigns[:root_comment_id] || assigns.comment.id

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
        <button phx-click={JS.show(to: "#reply-comment-#{@comment.id}")}>
          reply
        </button>
      </div>
      <div id={"reply-comment-#{@comment.id}"} class="hidden">
        <%= if @current_user do %>
          <.live_component
            module={AshWeb.CommentLive.FormComponent}
            id={"comment-new-child-#{@comment.id}"}
            comment={%Ash.Discussions.Comment{}}
            action={:new}
            post_id={@comment.post_id}
            user={@current_user}
            parent_comment_id={@comment.id}
            root_comment_id={root_comment_id}
            patch={~p"/c/#{@post.community.name}/comments/#{@comment.post_id}"}
          />
        <% end %>
      </div>
      <%= for comment <- @comment.child_comments do %>
        <div class="flex flex-row">
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
            root_comment_id={root_comment_id}
          />
        </div>
      <% end %>
    </div>
    """
  end
end

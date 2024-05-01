defmodule AshWeb.UserPageLive.UserTimelineComponent do
  alias Ash.Discussions.Post
  alias Ash.Discussions.Comment
  alias AshWeb.Components.PostComponent
  alias AshWeb.Components.VoteComponent

  use AshWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id="main-component-body"
      phx-update="stream"
      class="flex flex-col"
      phx-viewport-bottom="load-more"
    >
      <div :for={{_key, discussion} <- @discussions}>
        <%= if discussion.type == "post" do %>
          <div class="flex flex-row">
            <div class="mr-1">
              <.live_component
                module={VoteComponent}
                id={"vote-post-" <> Integer.to_string(discussion.id)}
                current_user={@current_user}
                voteable={struct(Post, discussion)}
              />
            </div>
            <PostComponent.post post={discussion} />
          </div>
        <% else %>
          <div class="flex flex-row">
            <div class="mr-1">
              <.live_component
                module={VoteComponent}
                id={"vote-comment" <> Integer.to_string(discussion.id)}
                current_user={@current_user}
                voteable={struct(Comment, discussion)}
              />
            </div>
            <AshWeb.Components.UserTimelineCommentComponent.comment comment={discussion} />
          </div>
        <% end %>
        <hr />
      </div>
    </div>
    """
  end
end

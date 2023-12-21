defmodule AshWeb.Components.UserTimelineComponent do
  alias Ash.Discussions.Post
  alias AshWeb.Components.PostComponent
  alias AshWeb.Components.VoteComponent

  use AshWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div
        id="main-component-body"
        phx-update="stream"
        class="flex flex-col"
        phx-viewport-bottom="load-more"
      >
        <%= for {_key, discussion} <- @discussions do %>
          <.live_component
            module={VoteComponent}
            id={"vote-discussion-#{discussion.id}"}
            current_user={@current_user}
            voteable={struct(Post, discussion)}
          />
          <PostComponent.post post={discussion} />
          <div class="mb-4" />
        <% end %>
      </div>
    </div>
    """
  end
end

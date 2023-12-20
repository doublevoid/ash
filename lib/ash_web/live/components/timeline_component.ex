defmodule AshWeb.Components.TimelineComponent do
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
        <%= for {_key, post} <- @posts do %>
          <.live_component
            module={VoteComponent}
            id={"vote-post-#{post.id}"}
            current_user={@current_user}
            voteable={post}
          />
          <PostComponent.post post={post} />
          <div class="mb-4" />
        <% end %>
      </div>
    </div>
    """
  end
end

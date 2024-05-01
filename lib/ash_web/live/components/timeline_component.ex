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
        <div :for={{_key, post} <- @posts} class="flex flex-row">
          <.live_component
            module={VoteComponent}
            id={"vote-post-#{post.id}"}
            current_user={@current_user}
            voteable={post}
          />
          <PostComponent.post post={post} />
        </div>
      </div>
    </div>
    """
  end
end

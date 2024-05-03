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
        <div :for={{_key, post} <- @posts} class="border-y-1">
          <div class="flex flex-row">
            <div class="basis-12">
              <.live_component
                module={VoteComponent}
                id={"vote-post-#{post.id}"}
                current_user={@current_user}
                voteable={post}
              />
            </div>
            <div>
              <PostComponent.post post={post} />
            </div>
           </div>
          <hr />
        </div>
      </div>
    </div>
    """
  end
end

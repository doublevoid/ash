defmodule AshWeb.FrontpageLive.MainComponent do
  alias AshWeb.Components.PostComponent
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
          <PostComponent.post post={post} />
          <div class="mb-4" />
        <% end %>
      </div>
      <div id="main-component-marker" phx-hook="InfiniteScroll" />
    </div>
    """
  end
end

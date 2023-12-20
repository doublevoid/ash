defmodule AshWeb.Components.VoteComponent do
  use AshWeb, :live_component

  def vote(assigns) do
    ~H"""
    <div>
      <div id="main-component-body" phx-update="replace" class="flex flex-col">
        <.icon name="hero-arrow-down-circle" class="ml-1 w-3 h-3" />
      </div>
    </div>
    """
  end
end

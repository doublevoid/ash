defmodule AshWeb.FrontpageLive.Show do
  use AshWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

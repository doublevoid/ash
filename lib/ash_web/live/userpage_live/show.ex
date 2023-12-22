defmodule AshWeb.UserpageLive.Show do
  use AshWeb, :live_view

  alias Ash.Discussions

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(
       :discussions,
       Discussions.user_timeline(socket.assigns.current_user, 0, 25)
     )
     |> assign(:offset, 0)
     |> assign(:limit, 25)}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit + 1 end)
      |> stream(:discussions, stream_new_discussions(socket))

    {:noreply, socket}
  end

  defp stream_new_discussions(socket) do
    offset = socket.assigns.offset
    limit = socket.assigns.limit
    Discussions.user_timeline(socket.assigns.current_user, offset, limit)
  end
end

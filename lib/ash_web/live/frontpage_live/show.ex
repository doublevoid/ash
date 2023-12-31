defmodule AshWeb.FrontpageLive.Show do
  use AshWeb, :live_view

  alias Ash.Discussions

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(
       :discussions,
       Discussions.posts_timeline(0, 25, nil, socket.assigns.current_user)
     )
     |> assign(:offset, 0)
     |> assign(:limit, 25)}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit end)
      |> stream(:discussions, stream_new_posts(socket))

    {:noreply, socket}
  end

  defp stream_new_posts(socket) do
    offset = socket.assigns.offset
    limit = socket.assigns.limit
    Discussions.posts_timeline(offset, limit, nil, socket.assigns.current_user)
  end
end

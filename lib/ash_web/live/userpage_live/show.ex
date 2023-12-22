defmodule AshWeb.UserpageLive.Show do
  alias Ash.Accounts
  use AshWeb, :live_view

  alias Ash.Discussions

  @impl true
  def mount(params, _session, socket) do
    user = Accounts.get_user_by_username!(params["username"])

    {:ok,
     socket
     |> stream(
       :discussions,
       Discussions.user_timeline(user, 0, 25)
     )
     |> assign(:user, user)
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
    Discussions.user_timeline(socket.assigns.user, offset, limit)
  end
end

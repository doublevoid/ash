defmodule AshWeb.UserpageLive.Show do
  alias Ash.Accounts
  use AshWeb, :live_view
  alias Ash.Discussions

  @user_page_discussion_load_size 25

  @impl true
  def mount(params, _session, socket) do
    user = Accounts.get_user_by_username!(params["username"])

    {discussions, discussion_count} =
      Discussions.user_timeline(
        0,
        @user_page_discussion_load_size,
        user,
        socket.assigns.current_user
      )

    {:ok,
     socket
     |> stream(
       :discussions,
       discussions
     )
     |> assign(:user, user)
     |> assign(:end_of_timeline?, discussion_count < @user_page_discussion_load_size)
     |> assign(:offset, @user_page_discussion_load_size)
     |> assign(:limit, @user_page_discussion_load_size)}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    {new_discussions, _discussion_count} = stream_new_discussions(socket)

    {:noreply,
     case new_discussions do
       [] ->
         socket
         |> assign(:end_of_timeline?, true)

       [_ | _] ->
         socket
         |> stream(:discussions, new_discussions)
         |> update(:offset, fn offset -> offset + socket.assigns.limit end)
         |> assign(:end_of_timeline?, false)
     end}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply, socket |> assign(:page_title, "/u/#{socket.assigns.user.username}")}
  end

  defp stream_new_discussions(socket) do
    offset = socket.assigns.offset
    limit = socket.assigns.limit

    Discussions.user_timeline(offset, limit, socket.assigns.user, socket.assigns.current_user)
  end
end

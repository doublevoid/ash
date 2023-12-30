defmodule AshWeb.PostLive.Show do
  use AshWeb, :live_view

  alias Ash.Discussions

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket) == true do
      {:ok,
       socket
       |> assign(
         :post,
         Discussions.get_post_with_extra_data!(params["id"], socket.assigns.current_user)
       )
       |> assign(
         :comments,
         Discussions.get_post_comments!(0, 25, params["id"], socket.assigns.current_user)
       )
       |> assign(:offset, 0)
       |> assign(:limit, 25)}
    else
      {:ok,
       socket
       |> assign(
         :post,
         Discussions.get_post_with_extra_data!(params["id"], socket.assigns.current_user)
       )
       |> assign(
         :comments,
         Discussions.get_post_comments!(0, 25, params["id"], socket.assigns.current_user)
       )}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
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

    Discussions.get_post_comments!(
      offset,
      limit,
      socket.assigns.post.id,
      socket.assigns.current_user
    )
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end

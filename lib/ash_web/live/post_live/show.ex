defmodule AshWeb.PostLive.Show do
  use AshWeb, :live_view

  alias Ash.Discussions

  @impl true
  def mount(params, _session, socket) do
    AshWeb.Endpoint.subscribe("post_#{params["id"]}")

    {:ok,
     socket
     |> assign(
       :post,
       Discussions.get_post_with_extra_data!(params["id"], socket.assigns.current_user)
     )
     |> stream(
       :comments,
       Discussions.get_post_comments!(0, 25, params["id"], socket.assigns.current_user)
     )
     |> assign(:offset, 0)
     |> assign(:limit, 25)}
  end

  @impl true
  def handle_params(%{"id" => _id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit end)
      |> stream(:comments, stream_new_comments(socket))

    {:noreply, socket}
  end

  @impl true
  def handle_event("load-replies", %{"value" => value}, socket) do
    root_thread =
      Discussions.get_comment_thread!(
        String.to_integer(value),
        socket.assigns.current_user
      )

    socket =
      socket
      |> stream_insert(:comments, root_thread)

    {:noreply, socket}
  end

  @impl true
  def handle_info({AshWeb.CommentLive.FormComponent, {:saved, comment, nil}}, socket) do
    socket =
      socket
      |> stream_insert(:comments, comment)

    {:noreply, socket}
  end

  def handle_info({AshWeb.CommentLive.FormComponent, {:saved, _comment, root_comment}}, socket) do
    root_thread = Discussions.get_comment_thread!(root_comment.id, socket.assigns.current_user)

    socket =
      socket
      |> stream_insert(:comments, root_thread)

    {:noreply, socket}
  end

  def handle_info(%{event: "new_comment", payload: {comment, nil}}, socket) do
    socket =
      socket
      |> stream_insert(:comments, comment)

    {:noreply, socket}
  end

  def handle_info(%{event: "new_comment", payload: {_comment, root_comment}}, socket) do
    root_thread = Discussions.get_comment_thread!(root_comment.id, socket.assigns.current_user)

    socket =
      socket
      |> stream_insert(:comments, root_thread)

    {:noreply, socket}
  end

  defp stream_new_comments(socket) do
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

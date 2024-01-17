defmodule AshWeb.CommunityLive.Show do
  alias Ash.Discussions.Post
  use AshWeb, :live_view

  alias Ash.Communities
  alias Ash.Discussions

  @impl true
  def mount(params, _session, socket) do
    community = Communities.get_community_by_name!(params["name"])

    {:ok,
     socket
     |> assign(:community, community)
     |> stream(:posts, Discussions.posts_timeline(0, 25, community.name))
     |> assign(:offset, 0)
     |> assign(:limit, 25)}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"name" => name}) do
    socket
    |> assign(:page_title, "Edit Community")
    |> assign(:community, Communities.get_community_by_name!(name))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :show, %{"name" => name}) do
    community = Communities.get_community_by_name!(name)

    socket
    |> assign(:page_title, "/c/#{community.name}")
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit end)
      |> stream(:posts, stream_new_posts(socket))

    IO.inspect("offset after stream")
    IO.inspect(socket.assigns.offset)
    IO.inspect("limit after stream")
    IO.inspect(socket.assigns.limit)

    {:noreply, socket}
  end

  defp stream_new_posts(socket) do
    offset = socket.assigns.offset
    limit = socket.assigns.limit
    Discussions.posts_timeline(offset, limit, socket.assigns.community.name)
  end
end

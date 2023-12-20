defmodule AshWeb.CommunityLive.Show do
  use AshWeb, :live_view

  alias Ash.Communities
  alias Ash.Discussions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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

  defp apply_action(socket, :show, %{"name" => name}) do
    community = Communities.get_community_by_name!(name)

    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:community, community)
    |> stream(:posts, Discussions.posts_timeline_by_community(0, 25, community.name))
    |> assign(:offset, 0)
    |> assign(:limit, 25)
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:offset, fn offset -> offset + socket.assigns.limit end)
      |> stream(:posts, stream_new_posts(socket))

    {:noreply, socket}
  end

  defp stream_new_posts(socket) do
    offset = socket.assigns.offset
    limit = socket.assigns.limit
    Discussions.posts_timeline_by_community(offset, limit, socket.assigns.community.name)
  end

  defp page_title(:show), do: "Show Community"
  defp page_title(:edit), do: "Edit Community"
end

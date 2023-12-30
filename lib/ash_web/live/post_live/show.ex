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
         Discussions.get_post_with_comments!(params["id"], socket.assigns.current_user)
       )}
    else
      {:ok,
       socket
       |> assign(
         :post,
         Discussions.get_post_with_small_comments(params["id"], socket.assigns.current_user)
       )}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end

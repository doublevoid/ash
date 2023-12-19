defmodule AshWeb.UserSubscriptionLive.Show do
  use AshWeb, :live_view

  alias Ash.Subscriptions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_subscription, Subscriptions.get_user_subscription!(id))}
  end

  defp page_title(:show), do: "Show User subscription"
  defp page_title(:edit), do: "Edit User subscription"
end

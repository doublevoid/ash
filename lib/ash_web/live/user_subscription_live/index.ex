defmodule AshWeb.UserSubscriptionLive.Index do
  use AshWeb, :live_view

  alias Ash.Subscriptions
  alias Ash.Subscriptions.UserSubscription

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_subscriptions, Subscriptions.list_user_subscriptions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User subscription")
    |> assign(:user_subscription, Subscriptions.get_user_subscription!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User subscription")
    |> assign(:user_subscription, %UserSubscription{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User subscriptions")
    |> assign(:user_subscription, nil)
  end

  @impl true
  def handle_info({AshWeb.UserSubscriptionLive.FormComponent, {:saved, user_subscription}}, socket) do
    {:noreply, stream_insert(socket, :user_subscriptions, user_subscription)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_subscription = Subscriptions.get_user_subscription!(id)
    {:ok, _} = Subscriptions.delete_user_subscription(user_subscription)

    {:noreply, stream_delete(socket, :user_subscriptions, user_subscription)}
  end
end

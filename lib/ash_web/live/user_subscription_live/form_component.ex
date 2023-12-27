defmodule AshWeb.UserSubscriptionLive.FormComponent do
  use AshWeb, :live_component

  alias Ash.Subscriptions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user_subscription records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_subscription-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save User subscription</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_subscription: user_subscription} = assigns, socket) do
    changeset = Subscriptions.change_user_subscription(user_subscription)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_subscription" => user_subscription_params}, socket) do
    changeset =
      socket.assigns.user_subscription
      |> Subscriptions.change_user_subscription(user_subscription_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user_subscription" => user_subscription_params}, socket) do
    save_user_subscription(socket, socket.assigns.action, user_subscription_params)
  end

  defp save_user_subscription(socket, :edit, user_subscription_params) do
    case Subscriptions.update_user_subscription(socket.assigns.user_subscription, user_subscription_params) do
      {:ok, user_subscription} ->
        notify_parent({:saved, user_subscription})

        {:noreply,
         socket
         |> put_flash(:info, "User subscription updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user_subscription(socket, :new, user_subscription_params) do
    case Subscriptions.create_user_subscription(user_subscription_params) do
      {:ok, user_subscription} ->
        notify_parent({:saved, user_subscription})

        {:noreply,
         socket
         |> put_flash(:info, "User subscription created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

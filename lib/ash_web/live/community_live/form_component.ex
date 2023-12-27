defmodule AshWeb.CommunityLive.FormComponent do
  use AshWeb, :live_component

  alias Ash.Communities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage community records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="community-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Community</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{community: community} = assigns, socket) do
    changeset = Communities.change_community(community)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"community" => community_params}, socket) do
    changeset =
      socket.assigns.community
      |> Communities.change_community(community_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"community" => community_params}, socket) do
    save_community(socket, socket.assigns.action, community_params)
  end

  defp save_community(socket, :edit, community_params) do
    case Communities.update_community(socket.assigns.community, community_params) do
      {:ok, community} ->
        notify_parent({:saved, community})

        {:noreply,
         socket
         |> put_flash(:info, "Community updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_community(socket, :new, community_params) do
    case Communities.create_community(community_params) do
      {:ok, community} ->
        notify_parent({:saved, community})

        {:noreply,
         socket
         |> put_flash(:info, "Community created successfully")
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

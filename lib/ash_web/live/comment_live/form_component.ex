defmodule AshWeb.CommentLive.FormComponent do
  use AshWeb, :live_component

  alias Ash.Discussions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id={"comment-form#{@parent_comment_id}"}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:body]}
          type="text"
          label="Body"
          id={"comment_body#{@parent_comment_id}"}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Discussions.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    params = merge_params(comment_params, socket)

    changeset =
      socket.assigns.comment
      |> Discussions.change_comment(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    params = merge_params(comment_params, socket)

    save_comment(socket, socket.assigns.action, params)
  end

  defp save_comment(socket, :edit, comment_params) do
    case Discussions.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment})

        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    case Discussions.create_comment(comment_params) do
      {:ok, comment} ->
        notify_parent({:saved, comment, socket.assigns[:root_comment]})
        broadcast_comment(comment, socket.assigns[:root_comment])

        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp broadcast_comment(comment, root_comment_id) do
    AshWeb.Endpoint.broadcast_from(
      self(),
      "post_#{comment.post_id}",
      "new_comment",
      {comment, root_comment_id}
    )
  end

  defp merge_params(comment_params, socket) do
    post_id = socket.assigns.post_id
    user_id = socket.assigns.user.id
    parent_comment_id = socket.assigns[:parent_comment_id]

    Map.merge(comment_params, %{
      "post_id" => post_id,
      "user_id" => user_id,
      "parent_comment_id" => parent_comment_id
    })
  end
end

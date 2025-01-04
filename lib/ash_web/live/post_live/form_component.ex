defmodule AshWeb.PostLive.FormComponent do
  use AshWeb, :live_component

  alias Ash.Discussions
  alias ExAws.S3

  #   <div>
  #   <%= for {_ref, msg} <- @uploads.image.errors do %>
  #     <h3>{Phoenix.Naming.humanize(msg)}</h3>
  #   <% end %>

  #   <%= for entry <- @uploads.image.entries do %>
  #     <.live_img_preview entry={entry} width="75" />
  #     <div class="py-5">{entry.progress}%</div>
  #   <% end %>
  # </div>

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage post records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input field={@form[:link]} type="text" label="Link" />
        <.live_file_input upload={@uploads.image} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Discussions.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png .webp), max_entries: 5)
     |> assign(:uploaded_images, [])
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    params = merge_params(post_params, socket)

    changeset =
      socket.assigns.post
      |> Discussions.change_post(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    params = merge_params(post_params, socket)

    saved_images = save_images(socket)

    save_post(socket, socket.assigns.action, params, saved_images)
  end

  defp save_post(socket, :edit, post_params, saved_images) do
    case Discussions.update_post(socket.assigns.post, post_params, saved_images) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :new, post_params, saved_images) do
    case Discussions.create_post(post_params, saved_images) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_images(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      binary = File.read!(path)
      grayscale_image = Ash.ImageProcessing.convert_to_grayscale(binary)
      path = "user-images/#{Path.basename(path)}.png"

      case S3.put_object(
             Application.fetch_env!(:ash, :aws_s3_bucket_name),
             path,
             grayscale_image
           )
           |> ExAws.request() do
        {:ok, _} -> {:ok, path}
        {:error, term} -> {:postpone, term}
      end
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp merge_params(post_params, socket) do
    community_id = socket.assigns.community.id
    user_id = socket.assigns.user.id

    Map.merge(post_params, %{
      "community_id" => community_id,
      "user_id" => user_id
    })
  end
end

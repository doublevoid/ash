defmodule AshWeb.Components.VoteComponent do
  alias Ash.Accounts.User
  alias Ash.Discussions
  alias Ash.Votes
  use AshWeb, :live_component

  @impl true
  def render(assigns) do
    voteable_type =
      case assigns.voteable.__struct__ do
        Ash.Discussions.Post -> "post"
        Ash.Discussions.Comment -> "comment"
      end

    assigns =
      assigns
      |> assign(:voteable_type, voteable_type)

    ~H"""
    <div>
      <div id={@id} phx-update="replace" class="flex flex-row">
        <div class="flex-grow flex-col text-center">
          <div
            phx-click="vote"
            phx-value-id={@voteable.id}
            phx-value-type={@voteable_type}
            phx-value-value={1}
            phx-target={@myself}
          >
            <.icon
              name="hero-arrow-up-circle"
              class={"w-3 h-3 #{if @current_user && @voteable.user_vote == 1, do: "bg-blue-600"}"}
            />
          </div>
          <p>
            <%= @voteable.karma || 0 %>
          </p>
          <div
            phx-click="vote"
            phx-value-id={@voteable.id}
            phx-value-type={@voteable_type}
            phx-value-value={-1}
            phx-target={@myself}
          >
            <.icon
              name="hero-arrow-down-circle"
              class={"w-3 h-3 #{if @current_user && @voteable.user_vote == -1, do: "bg-red-600"}"}
            />
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("vote", %{"id" => _id, "type" => type, "value" => value}, socket) do
    create_vote(socket, value, type)
  end

  defp create_vote(socket, value, type) do
    case socket.assigns.current_user do
      %User{} ->
        {:noreply,
         socket
         |> assign(voteable: handle_vote(socket, value, type))}

      _ ->
        {:noreply,
         socket
         |> Phoenix.LiveView.put_flash(:error, "You must log in to vote.")
         |> Phoenix.LiveView.redirect(to: ~p"/users/log_in")}
    end
  end

  defp update_post_vote(post, user) do
    Discussions.get_post_with_extra_data!(post.id, user)
  end

  defp update_comment_vote(comment, user) do
    Discussions.get_comment_with_extra_data!(comment.id, user)
  end

  defp handle_vote(socket, value, "post") do
    {value, _} = Integer.parse(value)
    post = socket.assigns.voteable
    user = socket.assigns.current_user

    case post.user_vote do
      ^value ->
        Votes.delete_post_vote(post, user)

      _ ->
        Votes.upsert_post_vote(%{
          post_id: post.id,
          user_id: user.id,
          value: value
        })
    end

    update_post_vote(post, user)
  end

  defp handle_vote(socket, value, "comment") do
    {value, _} = Integer.parse(value)
    comment = socket.assigns.voteable
    user = socket.assigns.current_user

    case comment.user_vote do
      ^value ->
        Votes.delete_comment_vote(comment, user)

      _ ->
        Votes.upsert_comment_vote(%{
          comment_id: comment.id,
          user_id: user.id,
          value: value
        })
    end

    update_comment_vote(comment, user)
  end
end

defmodule AshWeb.Components.VoteComponent do
  alias Ash.Discussions
  alias Ash.Votes.PostVote
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
      <div id={@id} phx-update="replace" class="flex flex-col text-center">
        <div
          phx-click="vote"
          phx-value-id={@voteable.id}
          phx-value-type={@voteable_type}
          phx-value-value={1}
          phx-target={@myself}
        >
          <.icon
            name="hero-arrow-up-circle"
            class={"w-3 h-3 #{if @current_user && Enum.any?(@voteable.votes, fn x -> x && x.value > 0 end), do: "bg-blue-600"}"}
          />
        </div>

        <div class="">
          <%= @voteable.karma || 0 %>
        </div>

        <div
          phx-click="vote"
          phx-value-id={@voteable.id}
          phx-value-type={@voteable_type}
          phx-value-value={-1}
          phx-target={@myself}
        >
          <.icon
            name="hero-arrow-down-circle"
            class={"w-3 h-3 #{if @current_user && Enum.any?(@voteable.votes, fn x -> x && x.value < 0 end), do: "bg-red-600"}"}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("vote", %{"id" => _id, "type" => "post", "value" => value}, socket) do
    unless socket.assigns.current_user do
      {:noreply,
       socket
       |> Phoenix.LiveView.put_flash(:error, "You must log in to vote.")
       |> Phoenix.LiveView.redirect(to: ~p"/users/log_in")}
    else
      {:noreply,
       socket
       |> assign(voteable: handle_vote(socket, value))}
    end
  end

  defp update_post_vote(post, post_vote) do
    Discussions.get_post_with_extra_data!(post.id)
  end

  defp handle_vote(socket, value) do
    vote = Enum.at(socket.assigns.voteable.votes, 0)
    post = socket.assigns.voteable

    post_vote =
      case vote do
        %PostVote{value: ^value} ->
          Votes.delete_post_vote(vote)
          nil

        _ ->
          {_, post_vote} =
            Votes.upsert_post_vote(%{
              post_id: post.id,
              user_id: socket.assigns.current_user.id,
              value: value
            })

          post_vote
      end

    update_post_vote(post, post_vote)
  end
end

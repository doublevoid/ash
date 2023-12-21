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
          phx-click="upvote"
          phx-value-id={@voteable.id}
          phx-value-type={@voteable_type}
          phx-target={@myself}
        >
          <.icon
            name="hero-arrow-up-circle"
            class={"w-3 h-3 #{if Enum.any?(@voteable.votes, fn x -> x && x.value > 0 end), do: "bg-blue-600"}"}
          />
        </div>

        <div class="">
          <%= @voteable.karma || 0 %>
        </div>

        <div
          phx-click="downvote"
          phx-value-id={@voteable.id}
          phx-value-type={@voteable_type}
          phx-target={@myself}
        >
          <.icon
            name="hero-arrow-down-circle"
            class={"w-3 h-3 #{if Enum.any?(@voteable.votes, fn x -> x && x.value < 0 end), do: "bg-red-600"}"}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("upvote", %{"id" => _id, "type" => "post"}, socket) do
    {:noreply,
     socket
     |> assign(voteable: handle_vote(socket, 1))}
  end

  @impl true
  def handle_event("downvote", %{"id" => _id, "type" => "post"}, socket) do
    {:noreply,
     socket
     |> assign(voteable: handle_vote(socket, -1))}
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

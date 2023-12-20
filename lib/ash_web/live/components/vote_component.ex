defmodule AshWeb.Components.VoteComponent do
  alias Ash.Votes.PostVote
  alias Ash.Votes
  use AshWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div id={@id} phx-update="replace" class="flex flex-col">
        <div phx-click="upvote" phx-value-id={@post.id} phx-value-type="post" phx-target={@myself}>
          <.icon
            name="hero-arrow-up-circle"
            class={"ml-1 w-3 h-3 #{if Enum.any?(@post.votes, fn x -> x && x.value > 0 end), do: "bg-blue-600"}"}
          />
        </div>

        <div phx-click="downvote" phx-value-id={@post.id} phx-value-type="post" phx-target={@myself}>
          <.icon
            name="hero-arrow-down-circle"
            class={"ml-1 w-3 h-3 #{if Enum.any?(@post.votes, fn x -> x && x.value < 0 end), do: "bg-red-600"}"}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("upvote", %{"id" => id, "type" => "post"}, socket) do
    vote = Enum.at(socket.assigns.post.votes, 0)

    post_vote =
      case vote do
        %PostVote{value: 1} ->
          Votes.delete_post_vote(vote)
          nil

        _ ->
          {_, post_vote} =
            Votes.upsert_post_vote(%{
              post_id: id,
              user_id: socket.assigns.current_user.id,
              value: 1
            })

          post_vote
      end

    {:noreply,
     socket
     |> assign(post: update_post_vote(socket.assigns.post, post_vote))}
  end

  @impl true
  def handle_event("downvote", %{"id" => id, "type" => "post"}, socket) do
    {_, post_vote} =
      Votes.upsert_post_vote(%{post_id: id, user_id: socket.assigns.current_user.id, value: -1})

    {:noreply,
     socket
     |> assign(post: update_post_vote(socket.assigns.post, post_vote))}
  end

  defp update_post_vote(post, post_vote) do
    %{post | votes: [post_vote]}
  end
end

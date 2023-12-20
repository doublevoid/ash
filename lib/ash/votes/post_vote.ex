defmodule Ash.Votes.PostVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field :value, :integer

    belongs_to :post, Ash.Discussions.Post
    belongs_to :user, Ash.Discussions.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post_vote, attrs) do
    post_vote
    |> cast(attrs, [:value, :post_id, :user_id])
    |> validate_required([:value, :post_id, :user_id])
    |> validate_number(:value, greater_than: -2, less_than: 2)
    |> assoc_constraint(:user)
    |> assoc_constraint(:post)
  end
end

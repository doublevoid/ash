defmodule Ash.Votes.PostVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field :value, :integer

    belongs_to :post, Ash.Discussions.Post
    belongs_to :user, Ash.Accounts.User

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(post_vote, attrs) do
    post_vote
    |> cast(attrs, [:value, :post_id, :user_id])
    |> validate_required([:value, :post_id, :user_id])
    |> validate_number(:value, greater_than: -2, less_than: 2)
    |> unique_constraint(:post_id, name: :post_votes_post_id_user_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:post)
  end
end

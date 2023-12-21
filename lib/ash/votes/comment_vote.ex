defmodule Ash.Votes.CommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment_votes" do
    field :value, :integer

    belongs_to :comment, Ash.Discussions.Comment
    belongs_to :user, Ash.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment_vote, attrs) do
    comment_vote
    |> cast(attrs, [:value, :comment_id, :user_id])
    |> validate_required([:value, :comment_id, :user_id])
    |> validate_number(:value, greater_than: -2, less_than: 2)
    |> unique_constraint(:comment_id, name: :comment_votes_comment_id_user_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:comment)
  end
end

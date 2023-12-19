defmodule Ash.Votes.CommentVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment_votes" do
    field :value, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment_vote, attrs) do
    comment_vote
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end

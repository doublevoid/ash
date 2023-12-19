defmodule Ash.Votes.PostVote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field :value, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post_vote, attrs) do
    post_vote
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end

defmodule Ash.Discussions.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :link, :string
    field :title, :string
    field :body, :string
    belongs_to :community, Ash.Communities.Community
    belongs_to :user, Ash.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :link, :community_id, :user_id])
    |> validate_required([:title, :body, :community_id, :user_id])
    |> assoc_constraint(:community)
    |> assoc_constraint(:user)
  end
end

defmodule Ash.Discussions.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :link, :string
    field :title, :string
    field :body, :string
    field :karma, :integer, default: 0
    field :user_vote, :integer, virtual: true

    belongs_to :community, Ash.Communities.Community
    belongs_to :user, Ash.Accounts.User

    has_many :comments, Ash.Discussions.Comment
    has_many :votes, Ash.Votes.PostVote
    has_many :images, Ash.Discussions.PostImage

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :link, :community_id, :user_id, :karma])
    |> validate_required([:title, :body, :community_id, :user_id, :karma])
    |> assoc_constraint(:community)
    |> assoc_constraint(:user)
  end
end

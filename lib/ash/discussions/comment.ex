defmodule Ash.Discussions.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :karma, :integer, virtual: true
    field :user_vote, :integer, virtual: true

    belongs_to :user, Ash.Accounts.User
    belongs_to :post, Ash.Discussions.Post
    belongs_to :parent_comment, Ash.Discussions.Comment
    has_many :votes, Ash.Votes.CommentVote
    has_many :child_comments, Ash.Discussions.Comment, foreign_key: :parent_comment_id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :user_id, :parent_comment_id])
    |> validate_required([:body, :post_id, :user_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
    |> assoc_constraint(:parent_comment)
  end
end

defmodule Ash.Votes do
  @moduledoc """
  The Votes context.
  """

  import Ecto.Query, warn: false
  alias Ash.Votes.CommentVote
  alias Ash.Discussions
  alias Ash.Discussions.Comment
  alias Ash.Discussions.Post
  alias Ash.Accounts.User
  alias Ash.Repo
  alias Ash.Votes.PostVote

  @doc """
  Returns the list of post_votes.

  ## Examples

      iex> list_post_votes()
      [%PostVote{}, ...]

  """
  def list_post_votes do
    Repo.all(PostVote)
  end

  @doc """
  Gets a single post_vote.

  Raises `Ecto.NoResultsError` if the Post vote does not exist.

  ## Examples

      iex> get_post_vote!(123)
      %PostVote{}

      iex> get_post_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_vote!(id), do: Repo.get!(PostVote, id)

  def upsert_post_vote(attrs \\ %{}), do: upsert_vote(PostVote, attrs)

  @doc """
  Updates a post_vote.

  ## Examples

      iex> update_post_vote(post_vote, %{field: new_value})
      {:ok, %PostVote{}}

      iex> update_post_vote(post_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_vote(%PostVote{} = post_vote, attrs) do
    post_vote
    |> PostVote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post_vote.

  ## Examples

      iex> delete_post_vote(post_vote)
      {:ok, %PostVote{}}

      iex> delete_post_vote(post_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_vote(%Post{} = post, %User{} = user), do: delete_vote(PostVote, post, user)


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_vote changes.

  ## Examples

      iex> change_post_vote(post_vote)
      %Ecto.Changeset{data: %PostVote{}}

  """
  def change_post_vote(%PostVote{} = post_vote, attrs \\ %{}) do
    PostVote.changeset(post_vote, attrs)
  end

  @doc """
  Returns the list of comment_votes.

  ## Examples

      iex> list_comment_votes()
      [%CommentVote{}, ...]

  """
  def list_comment_votes do
    Repo.all(CommentVote)
  end

  @doc """
  Gets a single comment_vote.

  Raises `Ecto.NoResultsError` if the Comment vote does not exist.

  ## Examples

      iex> get_comment_vote!(123)
      %CommentVote{}

      iex> get_comment_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment_vote!(id), do: Repo.get!(CommentVote, id)

  @doc """
  Creates a comment_vote.

  ## Examples

      iex> create_comment_vote(%{field: value})
      {:ok, %CommentVote{}}

      iex> create_comment_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_comment_vote(attrs \\ %{}), do: upsert_vote(CommentVote, attrs)

  @doc """
  Updates a comment_vote.

  ## Examples

      iex> update_comment_vote(comment_vote, %{field: new_value})
      {:ok, %CommentVote{}}

      iex> update_comment_vote(comment_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment_vote(%CommentVote{} = comment_vote, attrs) do
    comment_vote
    |> CommentVote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment_vote.

  ## Examples

      iex> delete_comment_vote(comment_vote)
      {:ok, %CommentVote{}}

      iex> delete_comment_vote(comment_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment_vote(%Comment{} = comment, %User{} = user), do: delete_vote(CommentVote, comment, user)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment_vote changes.

  ## Examples

      iex> change_comment_vote(comment_vote)
      %Ecto.Changeset{data: %CommentVote{}}

  """
  def change_comment_vote(%CommentVote{} = comment_vote, attrs \\ %{}) do
    CommentVote.changeset(comment_vote, attrs)
  end

  defp vote_foreign(PostVote), do: {:post_id, Post}

  defp vote_foreign(CommentVote), do: {:comment_id, Comment}

  defp upsert_vote(module, attrs) do
    {foreign_column, parent_module} = vote_foreign(module)

    existing_vote =
      Repo.get_by(module, user_id: attrs[:user_id], "#{foreign_column}": attrs[foreign_column])

    vote =
      struct(module)
      |> module.changeset(attrs)
      |> Repo.insert(
        on_conflict: [set: [value: attrs[:value]]],
        conflict_target: [foreign_column, :user_id]
      )

    karma_change = calculate_karma_change(existing_vote, attrs[:value])

    Discussions.update_discussion_karma(parent_module, attrs[foreign_column], karma_change)

    vote
  end

  defp delete_vote(module, discussion, user) do
    {foreign_column, parent_module} = vote_foreign(module)

    vote = Repo.get_by(module, "#{foreign_column}": discussion.id, user_id: user.id)

    Repo.delete(vote)

    Discussions.update_discussion_karma(parent_module, discussion.id, -vote.value)
  end

  defp calculate_karma_change(%{value: 1}, -1), do: -2

  defp calculate_karma_change(%{value: -1}, 1), do: 2

  defp calculate_karma_change(nil, new_value), do: new_value
end

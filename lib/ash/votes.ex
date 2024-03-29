defmodule Ash.Votes do
  @moduledoc """
  The Votes context.
  """

  import Ecto.Query, warn: false
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

  def upsert_post_vote(attrs \\ %{}) do
    existing_post_vote =
      Repo.get_by(PostVote, user_id: attrs[:user_id], post_id: attrs[:post_id])

    post_vote =
      %PostVote{}
      |> PostVote.changeset(attrs)
      |> Repo.insert(
        on_conflict: [set: [value: attrs[:value]]],
        conflict_target: [:post_id, :user_id]
      )

    karma_change =
      if existing_post_vote do
        calculate_karma_change(existing_post_vote.value, attrs[:value])
      else
        calculate_karma_change(nil, attrs[:value])
      end

    Discussions.update_post_karma(attrs[:post_id], karma_change)

    post_vote
  end

  defp calculate_karma_change(1, -1), do: -2

  defp calculate_karma_change(-1, 1), do: 2

  defp calculate_karma_change(nil, new_value), do: new_value

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
  def delete_post_vote(%Post{} = post, %User{} = user) do
    vote = Repo.get_by(PostVote, post_id: post.id, user_id: user.id)

    Repo.delete(vote)

    Discussions.update_post_karma(post.id, -vote.value)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_vote changes.

  ## Examples

      iex> change_post_vote(post_vote)
      %Ecto.Changeset{data: %PostVote{}}

  """
  def change_post_vote(%PostVote{} = post_vote, attrs \\ %{}) do
    PostVote.changeset(post_vote, attrs)
  end

  alias Ash.Votes.CommentVote

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
  def upsert_comment_vote(attrs \\ %{}) do
    existing_comment_vote =
      Repo.get_by(CommentVote, user_id: attrs[:user_id], comment_id: attrs[:comment_id])

    post_vote =
      %CommentVote{}
      |> CommentVote.changeset(attrs)
      |> Repo.insert(
        on_conflict: [set: [value: attrs[:value]]],
        conflict_target: [:comment_id, :user_id]
      )

    karma_change =
      if existing_comment_vote do
        calculate_karma_change(existing_comment_vote.value, attrs[:value])
      else
        calculate_karma_change(nil, attrs[:value])
      end

    Discussions.update_comment_karma(attrs[:comment_id], karma_change)

    post_vote
  end

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
  def delete_comment_vote(%Comment{} = comment, %User{} = user) do
    vote = Repo.get_by(CommentVote, comment_id: comment.id, user_id: user.id)

    Repo.delete(vote)

    Discussions.update_comment_karma(comment.id, -vote.value)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment_vote changes.

  ## Examples

      iex> change_comment_vote(comment_vote)
      %Ecto.Changeset{data: %CommentVote{}}

  """
  def change_comment_vote(%CommentVote{} = comment_vote, attrs \\ %{}) do
    CommentVote.changeset(comment_vote, attrs)
  end
end

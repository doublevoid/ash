defmodule Ash.Discussions do
  @moduledoc """
  The Discussions context.
  """

  import Ecto.Query, warn: false
  alias Ash.Votes.PostVote
  alias Ash.Accounts.User
  alias Ash.Repo

  alias Ash.Discussions.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def posts_timeline(offset, limit, community_name \\ nil, user \\ nil) do
    query =
      from(p in Post,
        join: c in assoc(p, :community),
        join: u in assoc(p, :user),
        left_join: v in assoc(p, :votes),
        preload: [community: c, user: u],
        select: p,
        select_merge: %{karma: sum(v.value)},
        offset: ^offset,
        limit: ^limit,
        order_by: :id,
        group_by: [p.id, c.id, u.id]
      )
      |> maybe_filter_community(community_name)
      |> maybe_join_user_votes(user)

    Repo.all(query)
  end

  defp maybe_filter_community(query, nil), do: query

  defp maybe_filter_community(query, community_name) do
    from([p, c] in query,
      where: c.name == ^community_name
    )
  end

  defp maybe_join_user_votes(query, nil), do: query

  defp maybe_join_user_votes(query, %User{} = user) do
    from([p, c, u, v] in query,
      left_join: uv in PostVote,
      on: uv.post_id == p.id and uv.user_id == u.id,
      where: uv.user_id == ^user.id,
      or_where: is_nil(v.user_id),
      preload: [votes: uv],
      group_by: [uv.id]
    )
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id, preloads \\ []), do: Repo.get!(Post, id) |> Repo.preload(preloads)

  def get_post_with_extra_data!(id) do
    query =
      from p in Post,
        left_join: v in PostVote,
        on: v.post_id == p.id,
        left_join: c in assoc(p, :community),
        left_join: u in assoc(p, :user),
        left_join: uv in PostVote,
        on: uv.post_id == p.id and uv.user_id == u.id,
        where: p.id == ^id,
        preload: [community: c, user: u, votes: uv],
        select: p,
        select_merge: %{karma: sum(v.value), current_user_vote: uv},
        group_by: [p.id, u.id, c.id, uv.id]

    IO.inspect(Repo.one(query))
    Repo.one(query)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Ash.Discussions.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end

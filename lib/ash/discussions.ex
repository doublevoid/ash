defmodule Ash.Discussions do
  @moduledoc """
  The Discussions context.
  """

  import Ecto.Query, warn: false
  alias Ash.Votes.CommentVote
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
      base_post_query()
      |> paginate_timeline(offset, limit)
      |> maybe_filter_community(community_name)
      |> maybe_join_user_votes(user, :post)

    Repo.all(query)
  end

  defp paginate_timeline(query, offset, limit) do
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  defp maybe_filter_community(query, nil), do: query

  defp maybe_filter_community(query, community_name) do
    from([p, c] in query,
      where: c.name == ^community_name
    )
  end

  defp maybe_join_user_votes(query, nil, _), do: query

  defp maybe_join_user_votes(query, %User{} = user, type) do
    vote_module = vote_module_for(type)
    id_field = id_field_for(type)

    from item in query,
      left_join: uv in ^vote_module,
      on: field(uv, ^id_field) == field(item, :id) and uv.user_id == ^user.id,
      select_merge: %{user_vote: max(uv.value)}
  end

  defp vote_module_for(:post), do: PostVote
  defp vote_module_for(:comment), do: CommentVote

  defp id_field_for(:post), do: :post_id
  defp id_field_for(:comment), do: :comment_id

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

  def get_post_with_extra_data!(id, user \\ nil) do
    query =
      base_post_query()
      |> maybe_join_user_votes(user, :post)
      |> where([p], p.id == ^id)

    Repo.one(query)
  end

  defp base_post_query() do
    from(p in Post,
      join: c in assoc(p, :community),
      join: u in assoc(p, :user),
      left_join: v in assoc(p, :votes),
      preload: [community: c, user: u],
      select: p,
      select_merge: %{karma: sum(v.value)},
      order_by: :id,
      group_by: [p.id, c.id, u.id]
    )
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

  def user_timeline(offset, limit, user, current_user \\ nil) do
    post_query =
      from(p in Post,
        join: c in assoc(p, :community),
        left_join: v in assoc(p, :votes),
        left_join: u in assoc(p, :user),
        select: %{
          type: "post",
          id: p.id,
          body: p.body,
          title: p.title,
          link: p.link,
          inserted_at: p.inserted_at,
          community: %{c | inserted_at: nil},
          user: %{u | inserted_at: nil},
          karma: sum(v.value),
          user_id: p.user_id
        },
        group_by: [c.id, p.id, u.id],
        where: p.user_id == ^user.id
      )
      |> maybe_join_user_votes(current_user, :post)

    union_query =
      from(c in Comment,
        join: p in assoc(c, :post),
        join: commu in assoc(p, :community),
        left_join: v in assoc(c, :votes),
        left_join: u in assoc(p, :user),
        select: %{
          type: "comment",
          id: c.id,
          body: c.body,
          title: p.title,
          link: p.link,
          inserted_at: c.inserted_at,
          community: %{commu | inserted_at: nil},
          user: %{u | inserted_at: nil},
          karma: sum(v.value),
          user_id: c.user_id
        },
        group_by: [c.id, p.id, commu.id, u.id],
        where: c.user_id == ^user.id
      )
      |> maybe_join_user_votes(current_user, :comment)
      |> union_all(^post_query)
      |> offset(^offset)
      |> limit(^limit)
      |> order_by(fragment("inserted_at DESC"))

    Repo.all(union_query)
  end
end

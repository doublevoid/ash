defmodule Ash.DiscussionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ash.Discussions` context.
  """
  alias Ash.AccountsFixtures
  alias Ash.CommunitiesFixtures

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        link: "some link",
        title: "some title",
        community_id: CommunitiesFixtures.community_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> Ash.Discussions.create_post()

    post
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body",
        post_id: post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> Ash.Discussions.create_comment()

    comment
  end
end

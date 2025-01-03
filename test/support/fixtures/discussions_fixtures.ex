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
        karma: 0,
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
        karma: 0,
        post_id: post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> Ash.Discussions.create_comment()

    comment
  end

  @doc """
  Generate a post_images.
  """
  def post_images_fixture(attrs \\ %{}) do
    {:ok, post_images} =
      attrs
      |> Enum.into(%{
        path: "some path",
        post_id: 42
      })
      |> Ash.Discussions.create_post_images()

    post_images
  end
end

defmodule Ash.VotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ash.Votes` context.
  """
  alias Ash.AccountsFixtures
  alias Ash.DiscussionsFixtures

  @doc """
  Generate a post_vote.
  """
  def post_vote_fixture(attrs \\ %{}) do
    {:ok, post_vote} =
      attrs
      |> Enum.into(%{
        value: Enum.at(Enum.take_random([-1, 1], 1), 0),
        post_id: DiscussionsFixtures.post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> Ash.Votes.upsert_post_vote()

    post_vote
  end

  @doc """
  Generate a comment_vote.
  """
  def comment_vote_fixture(attrs \\ %{}) do
    {:ok, comment_vote} =
      attrs
      |> Enum.into(%{
        value: Enum.at(Enum.take_random([-1, 1], 1), 0),
        comment_id: DiscussionsFixtures.comment_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> Ash.Votes.upsert_comment_vote()

    comment_vote
  end
end

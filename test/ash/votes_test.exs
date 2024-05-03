defmodule Ash.VotesTest do
  alias Ash.Discussions
  alias Ash.Accounts
  alias Ash.AccountsFixtures
  alias Ash.DiscussionsFixtures
  use Ash.DataCase

  alias Ash.Votes

  describe "post_votes" do
    alias Ash.Votes.PostVote

    import Ash.VotesFixtures

    @invalid_attrs %{
      value: 2,
      post_id: -1,
      user_id: -1
    }

    test "list_post_votes/0 returns all post_votes" do
      post_vote = post_vote_fixture()
      assert Votes.list_post_votes() == [post_vote]
    end

    test "get_post_vote!/1 returns the post_vote with given id" do
      post_vote = post_vote_fixture()
      assert Votes.get_post_vote!(post_vote.id) == post_vote
    end

    test "upsert/1 with valid data creates a post_vote" do
      valid_attrs = %{
        value: 1,
        post_id: DiscussionsFixtures.post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %PostVote{} = post_vote} = Votes.upsert_post_vote(valid_attrs)
      assert post_vote.value == 1
    end

    test "upsert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.upsert_post_vote(@invalid_attrs)
    end

    test "update_post_vote/2 with valid data updates the post_vote" do
      post_vote = post_vote_fixture()

      update_attrs = %{
        value: 1,
        post_id: DiscussionsFixtures.post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %PostVote{} = post_vote} = Votes.update_post_vote(post_vote, update_attrs)
      assert post_vote.value == 1
    end

    test "update_post_vote/2 with invalid data returns error changeset" do
      post_vote = post_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_post_vote(post_vote, @invalid_attrs)
      assert post_vote == Votes.get_post_vote!(post_vote.id)
    end

    test "delete_post_vote/1 deletes the post_vote" do
      post_vote = post_vote_fixture()

      assert {:ok, %PostVote{}} =
               Votes.delete_post_vote(
                 Discussions.get_post!(post_vote.post_id),
                 Accounts.get_user!(post_vote.user_id)
               )

      assert_raise Ecto.NoResultsError, fn -> Votes.get_post_vote!(post_vote.id) end
    end

    test "change_post_vote/1 returns a post_vote changeset" do
      post_vote = post_vote_fixture()
      assert %Ecto.Changeset{} = Votes.change_post_vote(post_vote)
    end
  end

  describe "comment_votes" do
    alias Ash.Votes.CommentVote

    import Ash.VotesFixtures

    @invalid_attrs %{
      value: 2,
      user_id: -1,
      comment_id: -1
    }

    test "list_comment_votes/0 returns all comment_votes" do
      comment_vote = comment_vote_fixture()
      assert Votes.list_comment_votes() == [comment_vote]
    end

    test "get_comment_vote!/1 returns the comment_vote with given id" do
      comment_vote = comment_vote_fixture()
      assert Votes.get_comment_vote!(comment_vote.id) == comment_vote
    end

    test "create_comment_vote/1 with valid data upserts a comment_vote" do
      valid_attrs = %{
        value: 1,
        comment_id: DiscussionsFixtures.comment_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %CommentVote{} = comment_vote} = Votes.upsert_comment_vote(valid_attrs)
      assert comment_vote.value == 1
    end

    test "upsert_comment_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.upsert_comment_vote(@invalid_attrs)
    end

    test "update_comment_vote/2 with valid data updates the comment_vote" do
      comment_vote = comment_vote_fixture()
      update_attrs = %{value: 1}

      assert {:ok, %CommentVote{} = comment_vote} =
               Votes.update_comment_vote(comment_vote, update_attrs)

      assert comment_vote.value == 1
    end

    test "update_comment_vote/2 with invalid data returns error changeset" do
      comment_vote = comment_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_comment_vote(comment_vote, @invalid_attrs)
      assert comment_vote == Votes.get_comment_vote!(comment_vote.id)
    end

    test "delete_comment_vote/1 deletes the comment_vote" do
      comment_vote = comment_vote_fixture()
      comment = Discussions.get_comment!(comment_vote.comment_id)
      user = Accounts.get_user!(comment_vote.user_id)

      assert {:ok, %CommentVote{}} =
               Votes.delete_comment_vote(comment, user)

      assert_raise Ecto.NoResultsError, fn -> Votes.get_comment_vote!(comment_vote.id) end
    end

    test "change_comment_vote/1 returns a comment_vote changeset" do
      comment_vote = comment_vote_fixture()
      assert %Ecto.Changeset{} = Votes.change_comment_vote(comment_vote)
    end
  end
end

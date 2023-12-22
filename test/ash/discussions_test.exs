defmodule Ash.DiscussionsTest do
  alias Ash.CommunitiesFixtures
  alias Ash.AccountsFixtures
  use Ash.DataCase

  alias Ash.Discussions

  describe "posts" do
    alias Ash.Discussions.Post

    import Ash.DiscussionsFixtures

    @invalid_attrs %{link: nil, title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Discussions.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Discussions.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{
        link: "some link",
        title: "some title",
        body: "some body",
        user_id: AccountsFixtures.user_fixture().id,
        community_id: CommunitiesFixtures.community_fixture().id
      }

      assert {:ok, %Post{} = post} = Discussions.create_post(valid_attrs)
      assert post.link == "some link"
      assert post.title == "some title"
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discussions.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        link: "some updated link",
        title: "some updated title",
        body: "some updated body"
      }

      assert {:ok, %Post{} = post} = Discussions.update_post(post, update_attrs)
      assert post.link == "some updated link"
      assert post.title == "some updated title"
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Discussions.update_post(post, @invalid_attrs)
      assert post == Discussions.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Discussions.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Discussions.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Discussions.change_post(post)
    end
  end

  describe "comments" do
    alias Ash.Discussions.Comment

    import Ash.DiscussionsFixtures

    @invalid_attrs %{body: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Discussions.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Discussions.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{
        body: "some body",
        post_id: post_fixture().id,
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Comment{} = comment} = Discussions.create_comment(valid_attrs)
      assert comment.body == "some body"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discussions.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Comment{} = comment} = Discussions.update_comment(comment, update_attrs)
      assert comment.body == "some updated body"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Discussions.update_comment(comment, @invalid_attrs)
      assert comment == Discussions.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Discussions.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Discussions.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Discussions.change_comment(comment)
    end
  end
end

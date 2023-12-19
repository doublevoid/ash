defmodule Ash.DiscussionsTest do
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
      valid_attrs = %{link: "some link", title: "some title", body: "some body"}

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
      update_attrs = %{link: "some updated link", title: "some updated title", body: "some updated body"}

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
end

defmodule AshWeb.PostVoteLiveTest do
  use AshWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ash.VotesFixtures

  @create_attrs %{value: 42}
  @update_attrs %{value: 43}
  @invalid_attrs %{value: nil}

  defp create_post_vote(_) do
    post_vote = post_vote_fixture()
    %{post_vote: post_vote}
  end

  describe "Index" do
    setup [:create_post_vote]

    test "lists all post_votes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/post_votes")

      assert html =~ "Listing Post votes"
    end

    test "saves new post_vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/post_votes")

      assert index_live |> element("a", "New Post vote") |> render_click() =~
               "New Post vote"

      assert_patch(index_live, ~p"/post_votes/new")

      assert index_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#post_vote-form", post_vote: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/post_votes")

      html = render(index_live)
      assert html =~ "Post vote created successfully"
    end

    test "updates post_vote in listing", %{conn: conn, post_vote: post_vote} do
      {:ok, index_live, _html} = live(conn, ~p"/post_votes")

      assert index_live |> element("#post_votes-#{post_vote.id} a", "Edit") |> render_click() =~
               "Edit Post vote"

      assert_patch(index_live, ~p"/post_votes/#{post_vote}/edit")

      assert index_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#post_vote-form", post_vote: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/post_votes")

      html = render(index_live)
      assert html =~ "Post vote updated successfully"
    end

    test "deletes post_vote in listing", %{conn: conn, post_vote: post_vote} do
      {:ok, index_live, _html} = live(conn, ~p"/post_votes")

      assert index_live |> element("#post_votes-#{post_vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post_votes-#{post_vote.id}")
    end
  end

  describe "Show" do
    setup [:create_post_vote]

    test "displays post_vote", %{conn: conn, post_vote: post_vote} do
      {:ok, _show_live, html} = live(conn, ~p"/post_votes/#{post_vote}")

      assert html =~ "Show Post vote"
    end

    test "updates post_vote within modal", %{conn: conn, post_vote: post_vote} do
      {:ok, show_live, _html} = live(conn, ~p"/post_votes/#{post_vote}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post vote"

      assert_patch(show_live, ~p"/post_votes/#{post_vote}/show/edit")

      assert show_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#post_vote-form", post_vote: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/post_votes/#{post_vote}")

      html = render(show_live)
      assert html =~ "Post vote updated successfully"
    end
  end
end

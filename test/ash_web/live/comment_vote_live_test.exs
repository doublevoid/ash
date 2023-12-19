defmodule AshWeb.CommentVoteLiveTest do
  use AshWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ash.VotesFixtures

  @create_attrs %{value: 42}
  @update_attrs %{value: 43}
  @invalid_attrs %{value: nil}

  defp create_comment_vote(_) do
    comment_vote = comment_vote_fixture()
    %{comment_vote: comment_vote}
  end

  describe "Index" do
    setup [:create_comment_vote]

    test "lists all comment_votes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/comment_votes")

      assert html =~ "Listing Comment votes"
    end

    test "saves new comment_vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/comment_votes")

      assert index_live |> element("a", "New Comment vote") |> render_click() =~
               "New Comment vote"

      assert_patch(index_live, ~p"/comment_votes/new")

      assert index_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comment_vote-form", comment_vote: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comment_votes")

      html = render(index_live)
      assert html =~ "Comment vote created successfully"
    end

    test "updates comment_vote in listing", %{conn: conn, comment_vote: comment_vote} do
      {:ok, index_live, _html} = live(conn, ~p"/comment_votes")

      assert index_live |> element("#comment_votes-#{comment_vote.id} a", "Edit") |> render_click() =~
               "Edit Comment vote"

      assert_patch(index_live, ~p"/comment_votes/#{comment_vote}/edit")

      assert index_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comment_vote-form", comment_vote: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comment_votes")

      html = render(index_live)
      assert html =~ "Comment vote updated successfully"
    end

    test "deletes comment_vote in listing", %{conn: conn, comment_vote: comment_vote} do
      {:ok, index_live, _html} = live(conn, ~p"/comment_votes")

      assert index_live |> element("#comment_votes-#{comment_vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#comment_votes-#{comment_vote.id}")
    end
  end

  describe "Show" do
    setup [:create_comment_vote]

    test "displays comment_vote", %{conn: conn, comment_vote: comment_vote} do
      {:ok, _show_live, html} = live(conn, ~p"/comment_votes/#{comment_vote}")

      assert html =~ "Show Comment vote"
    end

    test "updates comment_vote within modal", %{conn: conn, comment_vote: comment_vote} do
      {:ok, show_live, _html} = live(conn, ~p"/comment_votes/#{comment_vote}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Comment vote"

      assert_patch(show_live, ~p"/comment_votes/#{comment_vote}/show/edit")

      assert show_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#comment_vote-form", comment_vote: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/comment_votes/#{comment_vote}")

      html = render(show_live)
      assert html =~ "Comment vote updated successfully"
    end
  end
end

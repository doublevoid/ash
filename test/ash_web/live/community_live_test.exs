defmodule AshWeb.CommunityLiveTest do
  use AshWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ash.CommunitiesFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  defp create_community(_) do
    community = community_fixture()
    %{community: community}
  end

  describe "Index" do
    setup [:create_community]

    test "lists all communities", %{conn: conn, community: community} do
      {:ok, _index_live, html} = live(conn, ~p"/communities")

      assert html =~ "Listing Communities"
      assert html =~ community.name
    end

    test "saves new community", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/communities")

      assert index_live |> element("a", "New Community") |> render_click() =~
               "New Community"

      assert_patch(index_live, ~p"/communities/new")

      assert index_live
             |> form("#community-form", community: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#community-form", community: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/communities")

      html = render(index_live)
      assert html =~ "Community created successfully"
      assert html =~ "some name"
    end

    test "updates community in listing", %{conn: conn, community: community} do
      {:ok, index_live, _html} = live(conn, ~p"/communities")

      assert index_live |> element("#communities-#{community.id} a", "Edit") |> render_click() =~
               "Edit Community"

      assert_patch(index_live, ~p"/communities/#{community}/edit")

      assert index_live
             |> form("#community-form", community: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#community-form", community: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/communities")

      html = render(index_live)
      assert html =~ "Community updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes community in listing", %{conn: conn, community: community} do
      {:ok, index_live, _html} = live(conn, ~p"/communities")

      assert index_live |> element("#communities-#{community.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#communities-#{community.id}")
    end
  end

  describe "Show" do
    setup [:create_community]

    test "displays community", %{conn: conn, community: community} do
      {:ok, _show_live, html} = live(conn, ~p"/communities/#{community}")

      assert html =~ "Show Community"
      assert html =~ community.name
    end

    test "updates community within modal", %{conn: conn, community: community} do
      {:ok, show_live, _html} = live(conn, ~p"/communities/#{community}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Community"

      assert_patch(show_live, ~p"/communities/#{community}/show/edit")

      assert show_live
             |> form("#community-form", community: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#community-form", community: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/communities/#{community}")

      html = render(show_live)
      assert html =~ "Community updated successfully"
      assert html =~ "some updated name"
    end
  end
end

defmodule AshWeb.UserSubscriptionLiveTest do
  use AshWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ash.SubscriptionsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_user_subscription(_) do
    user_subscription = user_subscription_fixture()
    %{user_subscription: user_subscription}
  end

  describe "Index" do
    setup [:create_user_subscription]

    test "lists all user_subscriptions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/user_subscriptions")

      assert html =~ "Listing User subscriptions"
    end

    test "saves new user_subscription", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_subscriptions")

      assert index_live |> element("a", "New User subscription") |> render_click() =~
               "New User subscription"

      assert_patch(index_live, ~p"/user_subscriptions/new")

      assert index_live
             |> form("#user_subscription-form", user_subscription: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_subscription-form", user_subscription: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_subscriptions")

      html = render(index_live)
      assert html =~ "User subscription created successfully"
    end

    test "updates user_subscription in listing", %{conn: conn, user_subscription: user_subscription} do
      {:ok, index_live, _html} = live(conn, ~p"/user_subscriptions")

      assert index_live |> element("#user_subscriptions-#{user_subscription.id} a", "Edit") |> render_click() =~
               "Edit User subscription"

      assert_patch(index_live, ~p"/user_subscriptions/#{user_subscription}/edit")

      assert index_live
             |> form("#user_subscription-form", user_subscription: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_subscription-form", user_subscription: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_subscriptions")

      html = render(index_live)
      assert html =~ "User subscription updated successfully"
    end

    test "deletes user_subscription in listing", %{conn: conn, user_subscription: user_subscription} do
      {:ok, index_live, _html} = live(conn, ~p"/user_subscriptions")

      assert index_live |> element("#user_subscriptions-#{user_subscription.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_subscriptions-#{user_subscription.id}")
    end
  end

  describe "Show" do
    setup [:create_user_subscription]

    test "displays user_subscription", %{conn: conn, user_subscription: user_subscription} do
      {:ok, _show_live, html} = live(conn, ~p"/user_subscriptions/#{user_subscription}")

      assert html =~ "Show User subscription"
    end

    test "updates user_subscription within modal", %{conn: conn, user_subscription: user_subscription} do
      {:ok, show_live, _html} = live(conn, ~p"/user_subscriptions/#{user_subscription}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User subscription"

      assert_patch(show_live, ~p"/user_subscriptions/#{user_subscription}/show/edit")

      assert show_live
             |> form("#user_subscription-form", user_subscription: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_subscription-form", user_subscription: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_subscriptions/#{user_subscription}")

      html = render(show_live)
      assert html =~ "User subscription updated successfully"
    end
  end
end

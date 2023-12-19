defmodule Ash.SubscriptionsTest do
  use Ash.DataCase

  alias Ash.Subscriptions

  describe "user_subscriptions" do
    alias Ash.Subscriptions.UserSubscription

    import Ash.SubscriptionsFixtures

    @invalid_attrs %{}

    test "list_user_subscriptions/0 returns all user_subscriptions" do
      user_subscription = user_subscription_fixture()
      assert Subscriptions.list_user_subscriptions() == [user_subscription]
    end

    test "get_user_subscription!/1 returns the user_subscription with given id" do
      user_subscription = user_subscription_fixture()
      assert Subscriptions.get_user_subscription!(user_subscription.id) == user_subscription
    end

    test "create_user_subscription/1 with valid data creates a user_subscription" do
      valid_attrs = %{}

      assert {:ok, %UserSubscription{} = user_subscription} = Subscriptions.create_user_subscription(valid_attrs)
    end

    test "create_user_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_user_subscription(@invalid_attrs)
    end

    test "update_user_subscription/2 with valid data updates the user_subscription" do
      user_subscription = user_subscription_fixture()
      update_attrs = %{}

      assert {:ok, %UserSubscription{} = user_subscription} = Subscriptions.update_user_subscription(user_subscription, update_attrs)
    end

    test "update_user_subscription/2 with invalid data returns error changeset" do
      user_subscription = user_subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Subscriptions.update_user_subscription(user_subscription, @invalid_attrs)
      assert user_subscription == Subscriptions.get_user_subscription!(user_subscription.id)
    end

    test "delete_user_subscription/1 deletes the user_subscription" do
      user_subscription = user_subscription_fixture()
      assert {:ok, %UserSubscription{}} = Subscriptions.delete_user_subscription(user_subscription)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_user_subscription!(user_subscription.id) end
    end

    test "change_user_subscription/1 returns a user_subscription changeset" do
      user_subscription = user_subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_user_subscription(user_subscription)
    end
  end
end

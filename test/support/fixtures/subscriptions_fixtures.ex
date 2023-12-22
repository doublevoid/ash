defmodule Ash.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ash.Subscriptions` context.
  """
  alias Ash.CommunitiesFixtures
  alias Ash.AccountsFixtures

  @doc """
  Generate a user_subscription.
  """
  def user_subscription_fixture(attrs \\ %{}) do
    {:ok, user_subscription} =
      attrs
      |> Enum.into(%{
        user_id: AccountsFixtures.user_fixture().id,
        community_id: CommunitiesFixtures.community_fixture().id
      })
      |> Ash.Subscriptions.create_user_subscription()

    user_subscription
  end
end

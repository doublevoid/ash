defmodule Ash.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ash.Subscriptions` context.
  """

  @doc """
  Generate a user_subscription.
  """
  def user_subscription_fixture(attrs \\ %{}) do
    {:ok, user_subscription} =
      attrs
      |> Enum.into(%{

      })
      |> Ash.Subscriptions.create_user_subscription()

    user_subscription
  end
end

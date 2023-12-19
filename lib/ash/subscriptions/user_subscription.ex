defmodule Ash.Subscriptions.UserSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_subscriptions" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_subscription, attrs) do
    user_subscription
    |> cast(attrs, [])
    |> validate_required([])
  end
end

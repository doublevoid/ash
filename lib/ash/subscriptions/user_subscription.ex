defmodule Ash.Subscriptions.UserSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_subscriptions" do
    belongs_to :user, Ash.Accounts.User
    belongs_to :community, Ash.Communities.Community

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_subscription, attrs) do
    user_subscription
    |> cast(attrs, [:user_id, :community_id])
    |> validate_required([:user_id, :community_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:community)
  end
end

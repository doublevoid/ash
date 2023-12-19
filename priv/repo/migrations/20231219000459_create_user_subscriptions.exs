defmodule Ash.Repo.Migrations.CreateUserSubscriptions do
  use Ecto.Migration

  def change do
    create table(:user_subscriptions) do
      add :community_id, references(:communities)
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end

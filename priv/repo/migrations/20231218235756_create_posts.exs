defmodule Ash.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :"varchar(24)"
      add :body, :text
      add :link, :text
      add :user_id, references(:users)
      add :community_id, references(:communities)
      add :karma, :integer, default: 0

      timestamps(type: :utc_datetime_usec)
    end
  end
end

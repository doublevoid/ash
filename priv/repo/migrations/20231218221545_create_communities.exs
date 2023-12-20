defmodule Ash.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities) do
      add :name, :"varchar(24)"
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:communities, [:name])
  end
end

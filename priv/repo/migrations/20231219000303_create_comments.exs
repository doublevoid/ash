defmodule Ash.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :user_id, references(:users)
      add :post_id, references(:posts)

      timestamps(type: :utc_datetime)
    end
  end
end

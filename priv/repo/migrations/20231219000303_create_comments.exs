defmodule Ash.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :user_id, references(:users)
      add :post_id, references(:posts)
      add :parent_comment_id, references(:comments)

      timestamps(type: :utc_datetime_usec)
    end
  end
end

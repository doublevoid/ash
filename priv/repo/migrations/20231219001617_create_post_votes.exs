defmodule Ash.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add :value, :integer
      add :post_id, references(:posts)
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:post_votes, [:post_id, :user_id])
  end
end

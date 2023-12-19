defmodule Ash.Repo.Migrations.CreateCommentVotes do
  use Ecto.Migration

  def change do
    create table(:comment_votes) do
      add :value, :integer
      add :comment_id, references(:comments)
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end
  end
end

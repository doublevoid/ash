defmodule Ash.Repo.Migrations.AddPostImagesTable do
  use Ecto.Migration

  def change do
    create table(:post_images) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :image_url, :string

      timestamps()
    end
  end
end

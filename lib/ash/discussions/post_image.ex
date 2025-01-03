defmodule Ash.Discussions.PostImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_images" do
    field :path, :string

    belongs_to :post, Ash.Discussions.Post
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(post_image, attrs) do
    post_image
    |> cast(attrs, [:post_id, :path])
    |> validate_required([:post_id, :path])
    |> assoc_constraint(:post)
  end
end

defmodule Ash.Discussions.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :link, :string
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :link])
    |> validate_required([:title, :body, :link])
  end
end

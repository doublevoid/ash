defmodule Ash.CommunitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ash.Communities` context.
  """

  @doc """
  Generate a community.
  """
  def community_fixture(attrs \\ %{}) do
    {:ok, community} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Ash.Communities.create_community()

    community
  end
end

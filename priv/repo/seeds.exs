# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ash.Repo.insert!(%Ash.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Query
Ash.Repo.delete_all(from(p in Ash.Discussions.Post))

for i <- 1..75 do
  Ash.Discussions.create_post(%{
    title: "title #{i}",
    body: "body #{i}",
    link: "link #{i}",
    community_id: 1,
    user_id: 1
  })
end

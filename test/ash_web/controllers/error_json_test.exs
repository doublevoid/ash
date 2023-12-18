defmodule AshWeb.ErrorJSONTest do
  use AshWeb.ConnCase, async: true

  test "renders 404" do
    assert AshWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AshWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

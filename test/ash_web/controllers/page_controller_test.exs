defmodule AshWeb.PageControllerTest do
  use AshWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Register"
  end
end

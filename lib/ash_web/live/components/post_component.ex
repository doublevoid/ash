defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <p>Post title: <%= @post.title %></p>
    """
  end
end

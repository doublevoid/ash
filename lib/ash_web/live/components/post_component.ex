defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <p><%= @post.title %></p>
    <p>/c/<%= @post.community.name %></p>
    <p><%= @post.user.email %></p>
    """
  end
end

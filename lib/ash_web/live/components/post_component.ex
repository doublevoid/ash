defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <p><%= @post.title %></p>
    <.link href={~p"/c/#{@post.community.name}"} method="get">
      <p>/c/<%= @post.community.name %></p>
    </.link>
    <p><%= @post.user.username %></p>
    """
  end
end

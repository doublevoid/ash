defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <.link href={~p"/c/#{@post.community.name}/comments/#{@post.id}"}>
      <%= @post.title %>
    </.link>
    <.link href={~p"/c/#{@post.community.name}"}>
      /c/<%= @post.community.name %>
    </.link>
    <p><%= @post.user.username %></p>
    """
  end
end

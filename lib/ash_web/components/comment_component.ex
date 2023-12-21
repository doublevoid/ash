defmodule AshWeb.Components.CommentComponent do
  use AshWeb, :html

  def comment(assigns) do
    ~H"""
    <.link href={~p"/c/#{@comment.community.name}/comments/#{@comment.id}"}>
      <%= @comment.title %>
    </.link>
    <.link href={~p"/c/#{@comment.post.community.name}"}>
      /c/<%= @comment.community.name %>
    </.link>
    <p><%= @comment.user.username %></p>
    """
  end
end

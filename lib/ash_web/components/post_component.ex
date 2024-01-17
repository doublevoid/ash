defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.link patch={~p"/c/#{@post.community.name}/comments/#{@post.id}"}>
        <%= @post.title %>
      </.link>
      <div class="flex flex-row text-sm">
        <.link patch={~p"/c/#{@post.community.name}"}>
          /c/<%= @post.community.name %>
        </.link>
        <.link patch={~p"/u/#{@post.user.username}"} class="ml-1 mr-1">
          • Posted by /u/<%= @post.user.username %>
        </.link>
        <p>
          at: <%= @post.inserted_at %>
        </p>
      </div>
    </div>
    """
  end
end

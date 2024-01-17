defmodule AshWeb.Components.UserTimelineCommentComponent do
  use AshWeb, :html

  def comment(assigns) do
    ~H"""
    <div class="flex flex-col grow">
      <div class="flex flex-row">
        <.link patch={~p"/c/#{@comment.community.name}/comments/#{@comment.post_id}"}>
          <%= @comment.title %>
        </.link>
        <p class="text-sm">
          in
          <.link patch={~p"/c/#{@comment.community.name}"}>
            <%= @comment.community.name %>
          </.link>
          at <%= @comment.inserted_at %>
        </p>
      </div>
      <p><%= @comment.body %></p>
      <p>/u/<%= @comment.user.username %></p>
    </div>
    """
  end
end

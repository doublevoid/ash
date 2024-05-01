defmodule AshWeb.Components.UserTimelineCommentComponent do
  # This component name is a bit long, need to find a better one.
  use AshWeb, :html

  def comment(assigns) do
    ~H"""
    <div class="flex flex-col">
      <div class="flex flex-row">
        <.link patch={~p"/c/#{@comment.community.name}/comments/#{@comment.post_id}"}>
          <%= @comment.title %>
        </.link>
        <p class="ml-1 text-sm mt-0.5">
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

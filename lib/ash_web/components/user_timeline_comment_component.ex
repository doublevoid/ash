defmodule AshWeb.Components.UserTimelineCommentComponent do
  use AshWeb, :html

  def comment(assigns) do
    ~H"""
    <div class="flex flex-col">
      <p>
        <%= @comment.title || @comment.post.title %> in <%= if @comment.community,
          do: @comment.community.name,
          else: @comment.post.community.name %>
      </p>
      <p><%= @comment.body %></p>
      <p>/u/<%= @comment.user.username %></p>
    </div>
    """
  end
end

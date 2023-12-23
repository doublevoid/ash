defmodule AshWeb.Components.CommentComponent do
  use AshWeb, :html

  def comment(assigns) do
    ~H"""
    <div class="flex flex-col">
      <p><%= @comment.body %></p>
      <p>/u/<%= @comment.user.username %></p>
    </div>
    """
  end
end

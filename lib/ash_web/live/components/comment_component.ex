defmodule AshWeb.Components.CommentComponent do
  use AshWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <div class="flex flex-row text-sm">
        <.link href={~p"/u/#{@comment.user.username}"} class="mr-1">
          /u/<%= @comment.user.username %>
        </.link>
        <p>
          at: <%= @comment.inserted_at %>
        </p>
      </div>
      <div>
        <p>
          <%= @comment.body %>
        </p>
      </div>
      <%= if connected?(@socket) == true do %>
        <%= for comment <- @comment.child_comments do %>
          <.live_component
            module={AshWeb.Components.CommentComponent}
            id={"comment-#{comment.id}"}
            comment={comment}
          />
        <% end %>
      <% end %>
    </div>
    """
  end
end

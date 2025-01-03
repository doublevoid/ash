defmodule AshWeb.Components.PostComponent do
  use AshWeb, :html

  def post(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.link patch={~p"/c/#{@post.community.name}/comments/#{@post.id}"}>
        {@post.title}
      </.link>
      <div class="flex flex-row text-sm gap-1">
        <.link patch={~p"/c/#{@post.community.name}"}>
          /c/{@post.community.name}
        </.link>
        <span>• Posted by</span>
        <.link patch={~p"/u/#{@post.user.username}"}>
          /u/{@post.user.username}
        </.link>
        <p>
          at: {Calendar.strftime(@post.inserted_at, "%Y-%m-%d")}
        </p>
      </div>
    </div>
    """
  end
end

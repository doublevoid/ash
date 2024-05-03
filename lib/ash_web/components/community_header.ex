defmodule AshWeb.Components.CommunityHeaderComponent do
  use AshWeb, :html

  attr :community, :any

  def header(assigns) do
    ~H"""
    <div class="flex">
      <p>
        <.link patch={~p"/c/#{@community.name}"}>
          <%= "/c/#{@community.name}" %>
        </.link>
      </p>
    </div>
    """
  end
end

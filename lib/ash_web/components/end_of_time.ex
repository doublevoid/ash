defmodule AshWeb.Components.EndOfTime do
  use AshWeb, :html

  def render(assigns) do
    ~H"""
    <%= if @end_of_timeline do %>
      <div class="text-center">
        <p>Congrats, you've reached the end of time.</p>
      </div>
    <% end %>
    """
  end
end

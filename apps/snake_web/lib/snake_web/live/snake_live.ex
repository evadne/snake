defmodule SnakeWeb.SnakeLive do
  use SnakeWeb, :live_view
  alias Snake.Game.Backend
  alias SnakeWeb.Presence
  alias SnakeWeb.SnakeView
  @size 16

  @impl Phoenix.LiveView
  def mount(_params, _session, %{assigns: %{live_action: :new}} = socket) do
    {:ok, %{id: id}} = Snake.create()
    {:ok, push_redirect(socket, to: Routes.snake_path(socket, :show, id))}
  end

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, %{assigns: %{live_action: :show}} = socket) do
    {:ok, status, score, board} = Backend.call(id, :load)
    name = inspect(make_ref())
    count = map_size(Presence.list(id))

    if connected?(socket) do
      :ok = Backend.subscribe(id)
      :ok = subscribe(id)
      {:ok, _} = Presence.track(self(), id, socket.id, %{})
      :ok
    end

    socket = assign(socket, status: status, score: score, board: board)
    socket = assign(socket, name: name, id: id, votes: %{}, voted_heading: nil, size: @size)
    socket = assign(socket, count: count)
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(%{status: :halted} = assigns) do
    SnakeView.render("halted.html", assigns)
  end

  @impl Phoenix.LiveView
  def render(%{status: _} = assigns) do
    SnakeView.render("active.html", assigns)
  end

  @impl Phoenix.LiveView
  def handle_event("new_game", _, socket) do
    {:ok, %{id: id}} = Snake.create()
    :ok = publish(socket.assigns.id, {:new_game, id})
    {:noreply, push_redirect(socket, to: Routes.snake_path(socket, :show, id))}
  end

  @impl Phoenix.LiveView
  def handle_event("keydown", %{"key" => value}, socket) do
    handle_voted_heading(socket, value)
  end

  @impl Phoenix.LiveView
  def handle_event("vote-heading", %{"heading" => value}, socket) do
    handle_voted_heading(socket, value)
  end

  @impl Phoenix.LiveView
  def handle_info({:tick, status, score, board, votes}, socket) do
    # Sent from Backend
    socket = assign(socket, status: status, score: score, board: board, votes: votes)
    socket = assign(socket, voted_heading: nil)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:votes, votes}, socket) do
    # Sent from Backend
    {:noreply, assign(socket, votes: votes)}
  end

  @impl Phoenix.LiveView
  def handle_info({:new_game, game_id}, socket) do
    # Sent from fellow SnakeWeb.SnakeLive
    {:noreply, push_redirect(socket, to: Routes.snake_path(socket, :show, game_id))}
  end

  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    %{joins: joins, leaves: leaves} = payload
    count = socket.assigns.count + map_size(joins) - map_size(leaves)
    {:noreply, assign(socket, count: count)}
  end

  defp handle_voted_heading(socket, value) do
    if heading = get_heading(value) do
      :ok = Backend.call(socket.assigns.id, {:vote, heading})
      {:noreply, assign(socket, voted_heading: heading)}
    else
      {:noreply, socket}
    end
  end

  defp get_heading("ArrowUp"), do: :up
  defp get_heading("ArrowDown"), do: :down
  defp get_heading("ArrowLeft"), do: :left
  defp get_heading("ArrowRight"), do: :right
  defp get_heading("up"), do: :up
  defp get_heading("down"), do: :down
  defp get_heading("left"), do: :left
  defp get_heading("right"), do: :right
  defp get_heading(_), do: nil

  defp subscribe(game_id) do
    Phoenix.PubSub.subscribe(SnakeWeb.PubSub, game_id)
  end

  defp publish(game_id, message) do
    Phoenix.PubSub.broadcast(SnakeWeb.PubSub, game_id, message)
  end
end

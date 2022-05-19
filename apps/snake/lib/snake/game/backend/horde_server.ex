defmodule Snake.Game.Backend.HordeServer do
  use GenServer
  use SnakeEnvironment.Horde, namespace: Snake
  use Snake.Game.Backend

  @impl Snake.Game.Backend
  def call(game_id, message) do
    {:ok, pid} = Snake.Game.Backend.HordeServer.ensure_started({:game_id, game_id})
    GenServer.call(pid, message)
  end

  @impl SnakeEnvironment.Horde
  def registry_key({:game_id, game_id}), do: game_id

  @impl GenServer
  def init({:game_id, game_id}) do
    {:ok, State.init(game_id)}
  end

  @impl GenServer
  def handle_call(:load, _from, state) do
    {:reply, State.load(state), state}
  end

  @impl GenServer
  def handle_call({:vote, heading}, _from, state) do
    {:reply, :ok, State.vote(state, heading)}
  end

  @impl GenServer
  def handle_cast(_, %State{} = state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:tick, state) do
    {:noreply, State.tick(state)}
  end
end

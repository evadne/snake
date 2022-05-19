defmodule Snake.Game.Backend.ErleansGrain do
  use Snake.Game.Backend
  @behaviour :erleans_grain

  @impl Snake.Game.Backend
  def call(game_id, message) do
    grain_ref = :erleans.get_grain(__MODULE__, game_id)
    :erleans_grain.call(grain_ref, message)
  end

  @impl :erleans_grain
  def placement do
    :prefer_local
  end

  @impl :erleans_grain
  def state(game_id) do
    State.init(game_id)
  end

  @impl :erleans_grain
  def handle_call(:load, from, state) do
    {:ok, state, [{:reply, from, State.load(state)}]}
  end

  @impl :erleans_grain
  def handle_call({:vote, heading}, from, state) do
    {:ok, State.vote(state, heading), [{:reply, from, :ok}]}
  end

  @impl :erleans_grain
  def handle_cast(_, %State{} = state) do
    {:ok, state}
  end

  @impl :erleans_grain
  def handle_info(:tick, state) do
    {:ok, State.tick(state)}
  end
end

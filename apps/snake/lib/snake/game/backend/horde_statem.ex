defmodule Snake.Game.Backend.HordeStatem do
  use GenStateMachine, callback_mode: [:handle_event_function, :state_enter]
  use SnakeEnvironment.Horde, namespace: Snake
  use Snake.Game.Backend

  @timeout 45 * 60 * 1000
  @timeout_action {:state_timeout, @timeout, :activation_expiry}

  def start_link(term) do
    name = {:via, Horde.Registry, {Snake.Horde.Registry, registry_key(term)}}
    GenStateMachine.start_link(__MODULE__, term, name: name)
  end

  @impl Snake.Game.Backend
  def call(game_id, message) do
    {:ok, pid} = ensure_started({:game_id, game_id})
    GenStateMachine.call(pid, message)
  end

  @impl GenStateMachine
  def init({:game_id, game_id}) do
    {:ok, :active, State.init(game_id), [@timeout_action]}
  end

  @impl GenStateMachine
  def handle_event({:call, from}, :load, :active, data) do
    {:keep_state_and_data, [{:reply, from, State.load(data)}, @timeout_action]}
  end

  @impl GenStateMachine
  def handle_event({:call, from}, {:vote, heading}, :active, data) do
    {:repeat_state, State.vote(data, heading), [{:reply, from, :ok}, @timeout_action]}
  end

  @impl GenStateMachine
  def handle_event(:info, :tick, _state, data) do
    {:repeat_state, State.tick(data)}
  end

  @impl GenStateMachine
  def handle_event(:enter, _from_state, :active, _data) do
    {:keep_state_and_data, [@timeout_action]}
  end

  @impl GenStateMachine
  def handle_event(:enter, _from_state, :deactivating, _data) do
    {:stop, :normal}
  end

  @impl GenStateMachine
  def handle_event(:state_timeout, :activation_expiry, :active, data) do
    case data.status do
      :halted -> {:next_state, :deactivating, data}
      _ -> :repeat_state_and_data
    end
  end
end

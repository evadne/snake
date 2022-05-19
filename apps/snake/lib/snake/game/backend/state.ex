defmodule Snake.Game.State do
  alias Snake.Board
  alias Snake.Game
  alias Snake.Game.Backend
  alias SnakeData.Repo
  @tick 500

  @type t :: %__MODULE__{
          game: Game.t(),
          timer: :timer.tref() | nil,
          status: :pending | :active | :halted,
          score: non_neg_integer(),
          heading: nil | :up | :down | :left | :right,
          votes: %{required(:up | :down | :left | :right) => non_neg_integer()},
          board: Board.t()
        }

  defstruct game: nil,
            timer: nil,
            status: :pending,
            score: 0,
            heading: nil,
            votes: %{},
            board: nil

  def init(game_id) do
    game = Repo.get(Game, game_id)
    status = String.to_existing_atom(game.status)
    score = game.score
    board = Board.decode(game.board_snapshot)
    %__MODULE__{game: game, status: status, score: score, board: board}
  end

  def load(%__MODULE__{} = state) do
    {:ok, state.status, state.score, state.board}
  end

  def vote(%__MODULE__{} = state, heading) do
    state = %{state | votes: Map.update(state.votes, heading, 1, &(&1 + 1))}
    state = maybe_start_timer(state)
    :ok = Backend.publish(state.game.id, {:votes, state.votes})
    state
  end

  def tick(%__MODULE__{status: :halted} = state) do
    {:ok, :cancel} = :timer.cancel(state.timer)
    %{state | timer: nil}
  end

  def tick(%__MODULE__{} = state) do
    state = state |> next() |> save()
    message = {:tick, state.status, state.score, state.board, state.votes}
    :ok = Backend.publish(state.game.id, message)
    state
  end

  defp save(%__MODULE__{} = state) do
    board_snapshot = Board.encode(state.board)
    changes = %{status: to_string(state.status), score: state.score, board: board_snapshot}
    {:ok, game} = Repo.update(Game.update_changeset(state.game, changes))
    %{state | game: game}
  end

  defp next(%__MODULE__{} = state) do
    comparator = fn {_, lhs}, {_, rhs} -> lhs >= rhs end
    {voted_heading, _} = Enum.max(state.votes, comparator, fn -> {state.heading, 0} end)
    state = %{state | votes: %{}}

    case Board.advance(state.board, voted_heading) do
      {:grow, board} -> %{state | board: board, heading: voted_heading, score: state.score + 1}
      {:cont, board} -> %{state | board: board, heading: voted_heading}
      {:done, board} -> %{state | board: board, status: :halted}
      {:halt, board} -> %{state | board: board, status: :halted}
    end
  end

  defp maybe_start_timer(%__MODULE__{status: :halted} = state) do
    state
  end

  defp maybe_start_timer(%__MODULE__{timer: timer} = state) when not is_nil(timer) do
    state
  end

  defp maybe_start_timer(%__MODULE__{timer: nil} = state) do
    {:ok, timer} = :timer.send_interval(@tick, :tick)
    %{state | timer: timer}
  end
end

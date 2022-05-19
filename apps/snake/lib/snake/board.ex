defmodule Snake.Board do
  @moduledoc """
  Represents the board with various members:

  - The basic parameters (width and height of the board)
  - The snake (list of `{x, y}` from head to tail)
  - The location of cherries (list of `{x, y}`)
  - The location of obstacles (list of `{x, y}`)

  Note that the snake, cherries, and obstacles must not overlap for the board to be valid.

  The coordinate system has the origin at the top left corner, with both X and Y axis incrementing
  to the right and to the bottom.

  The heading of the snake is not part of the board
  """

  defstruct width: 0,
            height: 0,
            snake: [{0, 0}],
            obstacles: [],
            cherries: [],
            spaces: []

  @type x :: non_neg_integer()
  @type y :: non_neg_integer()
  @type width :: non_neg_integer()
  @type height :: non_neg_integer()

  @type t :: %__MODULE__{
          width: non_neg_integer(),
          height: non_neg_integer(),
          snake: nonempty_list({x :: non_neg_integer(), y :: non_neg_integer()}),
          obstacles: list({x, y}),
          cherries: list({x, y}),
          spaces: list({x, y})
        }

  def generate(width, height)

  def generate(width, height) when width < 3 or height < 3 do
    {:error, :insufficient_size}
  end

  def generate(width, height) do
    snake = [{ceil(width / 2), ceil(height / 2)}]
    spaces = Enum.shuffle(for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y})
    board = %__MODULE__{width: width, height: height, snake: snake, spaces: spaces}
    count_obstacles = min(5, floor(0.125 * length(board.spaces)))
    count_cherries = min(5, floor(0.25 * length(board.spaces)))

    with {:ok, board} <- place_obstacles(board, count_obstacles),
         {:ok, board} <- place_cherries(board, count_cherries) do
      {:ok, board}
    end
  end

  def place_obstacles(board, count) do
    with true <- count > 0,
         {:ok, board} <- place_obstacle(board) do
      place_obstacles(board, count - 1)
    else
      false -> {:ok, board}
      {:error, reason} -> {:error, reason}
    end
  end

  def place_obstacle(%__MODULE__{} = board), do: place_obstacle(board, board.spaces)

  defp place_obstacle(_, []) do
    {:error, :full}
  end

  defp place_obstacle(%{obstacles: obstacles, spaces: spaces} = board, [spot | rest_spaces]) do
    cond do
      Enum.member?(board.snake, spot) -> place_obstacle(board, rest_spaces)
      true -> {:ok, %{board | obstacles: [spot | obstacles], spaces: spaces -- [spot]}}
    end
  end

  def place_cherries(board, count) do
    with true <- count > 0,
         {:ok, board} <- place_cherry(board) do
      place_cherries(board, count - 1)
    else
      false -> {:ok, board}
      {:error, reason} -> {:error, reason}
    end
  end

  def place_cherry(%__MODULE__{} = board), do: place_cherry(board, board.spaces)

  defp place_cherry(_, []) do
    {:error, :full}
  end

  defp place_cherry(%{cherries: cherries, spaces: spaces} = board, [spot | rest_spaces]) do
    cond do
      Enum.member?(board.snake, spot) -> place_cherry(board, rest_spaces)
      true -> {:ok, %{board | cherries: [spot | cherries], spaces: spaces -- [spot]}}
    end
  end

  defp shift(position, heading)
  defp shift({x, y}, :up), do: {x, y - 1}
  defp shift({x, y}, :down), do: {x, y + 1}
  defp shift({x, y}, :left), do: {x - 1, y}
  defp shift({x, y}, :right), do: {x + 1, y}

  defp what(board, {x, y} = position) do
    cond do
      x < 0 -> :obstacle
      x >= board.width -> :obstacle
      y < 0 -> :obstacle
      y >= board.height -> :obstacle
      Enum.member?(board.snake, position) -> :snake
      Enum.member?(board.cherries, position) -> :cherry
      Enum.member?(board.obstacles, position) -> :obstacle
      true -> nil
    end
  end

  def advance(%__MODULE__{snake: [head_from | _] = snake} = board, heading) do
    head_to = shift(head_from, heading)

    with :cherry <- what(board, head_to),
         board = %{board | snake: [head_to | snake], cherries: board.cherries -- [head_to]} do
      case place_cherry(board) do
        {:ok, board} -> {:grow, board}
        {:error, _reason} -> {:done, board}
      end
    else
      nil -> {:cont, %{board | snake: [head_to | Enum.drop(board.snake, -1)]}}
      :obstacle -> {:halt, board}
      :snake -> {:halt, board}
    end
  end

  def encode(%__MODULE__{} = board) do
    value = {board.width, board.height, board.snake, board.cherries, board.obstacles}
    :erlang.term_to_binary(value)
  end

  def decode(binary) do
    {width, height, snake, cherries, obstacles} = :erlang.binary_to_term(binary)
    spaces = Enum.shuffle(for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y})
    spaces = ((spaces -- snake) -- cherries) -- obstacles

    %__MODULE__{
      width: width,
      height: height,
      snake: snake,
      obstacles: obstacles,
      cherries: cherries,
      spaces: spaces
    }
  end
end

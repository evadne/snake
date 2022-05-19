defmodule Snake do
  alias SnakeData.Repo

  def create do
    create(35, 35)
  end

  def create(width, height) do
    {:ok, board} = Snake.Board.generate(width, height)
    board_snapshot = Snake.Board.encode(board)
    game_params = %{board_width: width, board_height: height, board_snapshot: board_snapshot}
    game = Snake.Game.create_changeset(game_params)
    Repo.insert(game)
  end

  def get_latest_available do
    import Ecto.Query

    Snake.Game
    |> where([x], x.status != "halted")
    |> order_by([x], desc: x.updated_at)
    |> limit(1)
    |> Repo.one()
  end
end

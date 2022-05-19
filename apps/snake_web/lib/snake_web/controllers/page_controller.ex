defmodule SnakeWeb.PageController do
  use SnakeWeb, :controller

  def index(conn, _params) do
    latest_snake = Snake.get_latest_available()
    render(conn, "index.html", latest_snake: latest_snake)
  end
end

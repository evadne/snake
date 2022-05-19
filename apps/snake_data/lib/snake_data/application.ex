defmodule SnakeData.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SnakeData.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SnakeData.Supervisor)
  end
end

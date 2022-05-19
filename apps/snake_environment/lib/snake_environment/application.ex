defmodule SnakeEnvironment.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      SnakeEnvironment.Horde.Tracker,
      SnakeEnvironment.Cluster.Supervisor
    ]

    opts = [strategy: :one_for_one, name: SnakeEnvironment.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

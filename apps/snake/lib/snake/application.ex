defmodule Snake.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Horde.Registry, [name: Snake.Horde.Registry, keys: :unique]},
      {Horde.DynamicSupervisor, [name: Snake.Horde.Supervisor, strategy: :one_for_one]},
      {SnakeEnvironment.Horde.Client, [name: Snake.Horde.Client, target: Snake]},
      {Phoenix.PubSub, name: Snake.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Snake.Supervisor)
  end
end

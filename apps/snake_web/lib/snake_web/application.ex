defmodule SnakeWeb.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: SnakeWeb.PubSub},
      SnakeWeb.Presence,
      SnakeWeb.Telemetry,
      SnakeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: SnakeWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SnakeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

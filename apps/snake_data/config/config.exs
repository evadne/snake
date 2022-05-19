import Config

config :snake_data, ecto_repos: [SnakeData.Repo]

config :snake_data, SnakeData.Repo,
  adapter: Ecto.Adapters.Postgres,
  socket_options: [
    keepalive: true
  ]

import_config "#{config_env()}.exs"

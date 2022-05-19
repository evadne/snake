import Config

config :snake_data, SnakeData.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 5 * 60 * 1000

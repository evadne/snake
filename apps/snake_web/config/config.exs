import Config

config :snake_web, generators: [context_app: :snake]

config :snake_web, SnakeWeb.Endpoint,
  render_errors: [view: SnakeWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: SnakeWeb.PubSub

import_config "#{config_env()}.exs"

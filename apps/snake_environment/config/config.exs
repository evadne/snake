import Config

config :snake_environment, SnakeEnvironment, strategies: []

import_config "#{config_env()}.exs"

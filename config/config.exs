import Config

for config <- "../apps/*/config/config.exs" |> Path.expand(__DIR__) |> Path.wildcard() do
  import_config config
end

if config_env() != :test do
  routes = [
    snake_web: {SnakeWeb.Endpoint, "/"}
  ]

  config :snake_proxy, SnakeProxy,
    applications: Enum.uniq(Enum.map(routes, &elem(&1, 0))),
    endpoints: Enum.map(routes, &elem(&1, 1))

  for {app, {endpoint, mount}} <- routes do
    config(app, endpoint, url: [path: mount])
  end
end

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

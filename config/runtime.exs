import Config

# maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []
#
#   config :snake, Snake.Repo,
#     # ssl: true,
#     url: database_url,
#     pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
#     socket_options: maybe_ipv6
#
#   # The secret key base is used to sign/encrypt cookies and other secrets.
#   # A default value is used in config/dev.exs and config/test.exs but you
#   # want to use a different value for prod and you most likely don't want
#   # to check this value into version control, so we use an environment
#   # variable instead.
#   secret_key_base =
#     System.get_env("SECRET_KEY_BASE") ||
#       raise """
#       environment variable SECRET_KEY_BASE is missing.
#       You can generate one by calling: mix phx.gen.secret
#       """
#
#   config :snake_web, SnakeWeb.Endpoint,
#     http: [
#       # Enable IPv6 and bind on all interfaces.
#       # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
#       ip: {0, 0, 0, 0, 0, 0, 0, 0},
#       port: String.to_integer(System.get_env("PORT") || "4000")
#     ],
#     secret_key_base: secret_key_base
#
#   config :snake_web, SnakeWeb.Endpoint, server: true
# end

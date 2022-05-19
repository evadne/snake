defmodule SnakeWeb.Endpoint do
  @otp_app Mix.Project.config()[:app]
  use Phoenix.Endpoint, otp_app: @otp_app

  @session_options [
    store: :cookie,
    key: "_snake_web_key",
    signing_salt: "sRR3qZA6"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :snake_web,
    gzip: false,
    only: ~w(assets favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :snake_data
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug SnakeWeb.Router

  def init(_, config) do
    SnakeEnvironment.Endpoint.init(config)
  end
end

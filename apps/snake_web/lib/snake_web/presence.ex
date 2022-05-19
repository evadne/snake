defmodule SnakeWeb.Presence do
  use Phoenix.Presence, otp_app: :snake_web, pubsub_server: SnakeWeb.PubSub
end

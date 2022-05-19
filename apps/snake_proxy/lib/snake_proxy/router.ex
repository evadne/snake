defmodule SnakeProxy.Router do
  use Phoenix.Router

  for {endpoint, mount} <- SnakeProxy.get_endpoints() do
    forward mount, endpoint
  end
end

defmodule SnakeProxy.Cowboy do
  def build_child_spec do
    Plug.Cowboy.child_spec(
      plug: nil,
      scheme: :http,
      options: [
        port: SnakeProxy.get_port(),
        dispatch: build_dispatch(),
        protocol_options: [
          idle_timeout: 60000,
          inactivity_timeout: 60000
        ]
      ]
    )
  end

  defp build_dispatch do
    [{:_, build_dispatch_websockets() ++ [build_dispatch_plug()]}]
  end

  defp build_dispatch_websockets do
    Enum.flat_map(SnakeProxy.get_endpoints(), fn {endpoint, mount} ->
      Enum.map(endpoint.__sockets__(), fn {path, socket_module, options} ->
        path = Path.join([mount, path, "websocket"])
        socket_options = build_dispatch_socket_options(endpoint, socket_module, options)
        handler_state = {{endpoint, mount}, {socket_module, socket_options}}
        {path, SnakeProxy.WebsocketHandler, handler_state}
      end)
    end)
  end

  defp build_dispatch_plug do
    {:_, Plug.Cowboy.Handler, {SnakeProxy.Router, []}}
  end

  defp build_dispatch_socket_options(_endpoint, _socket_module, _options) do
    :websocket
  end
end

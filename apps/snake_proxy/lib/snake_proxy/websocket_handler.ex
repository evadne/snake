defmodule SnakeProxy.WebsocketHandler do
  @behaviour :cowboy_websocket
  @upstream Phoenix.Endpoint.Cowboy2Handler

  @impl :cowboy_websocket
  def init(request, {{endpoint, mount}, opts}) do
    request_path = String.replace_prefix(request.path, mount, "")
    request = %{request | path: request_path}
    @upstream.init(request, {endpoint, opts})
  end

  @impl :cowboy_websocket
  defdelegate websocket_init(state), to: @upstream

  @impl :cowboy_websocket
  defdelegate websocket_handle(in_frame, state), to: @upstream

  @impl :cowboy_websocket
  defdelegate websocket_info(info, state), to: @upstream

  @impl :cowboy_websocket
  defdelegate terminate(reason, partial_request, state), to: @upstream
end

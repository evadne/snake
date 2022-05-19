defmodule Snake.Game.Backend do
  @otp_app Mix.Project.config()[:app]
  @backend_module Application.fetch_env!(@otp_app, :backend_module)
  defdelegate call(game_id, message), to: @backend_module

  @callback call(term(), term()) :: {:ok, term()} | {:error, term()}

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
      alias Snake.Game.State
    end
  end

  def subscribe(game_id) do
    Phoenix.PubSub.subscribe(Snake.PubSub, game_id)
  end

  def publish(game_id, message) do
    Phoenix.PubSub.broadcast(Snake.PubSub, game_id, message)
  end
end

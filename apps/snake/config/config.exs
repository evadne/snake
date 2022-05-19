import Config

config :snake,
  backend_module: Snake.Game.Backend.HordeStatem

config :erleans,
  providers: %{
    in_memory: %{
      module: :erleans_provider_ets,
      args: %{}
    }
  },
  default_provider: :in_memory

config :lasp,
  membership: true,
  storage_backend: :lasp_ets_storage_backend,
  mode: :delta_based,
  delta_interval: 200

config :plumtree,
  broadcast_exchange_timer: 60000,
  broadcast_mods: [:lasp_plumtree_backend]

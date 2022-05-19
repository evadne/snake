defmodule Snake.MixProject do
  use Mix.Project

  def project do
    [
      app: :snake,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Snake.Application, []},
      extra_applications: [:logger, :runtime_tools, :gen_state_machine]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:snake_environment, in_umbrella: true},
      {:gen_state_machine, "~> 3.0.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:snake_data, in_umbrella: true}
    ]
  end
end

defmodule SnakeEnvironment.MixProject do
  use Mix.Project

  def project do
    [
      app: :snake_environment,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {SnakeEnvironment.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    otel_api = "open-telemetry/opentelemetry-erlang-api"

    [
      {:horde, "~> 0.8.4"},
      {:libcluster, "~> 3.2.2"},
      {:erleans, github: "erleans/erleans", ref: "ecccf9e", override: true},
      {:opentelemetry_api, github: otel_api, ref: "48da648", override: true}
    ]
  end
end

defmodule Snake.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :mnesia, :iex, :ex_unit],
      flags: ~w(error_handling no_opaque race_conditions underspecs unmatched_returns)a,
      ignore_warnings: "dialyzer-ignore-warnings.exs",
      list_unused_filters: true
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run --no-start scripts/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      setup: ["deps.get", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp releases do
    [
      snake: [
        version: "0.0.1",
        include_executables_for: [:unix],
        applications: [
          snake: :permanent,
          snake_data: :permanent,
          snake_environment: :permanent,
          snake_proxy: :permanent,
          snake_web: :permanent
        ]
      ]
    ]
  end
end

defmodule SnakeData.Release do
  @otp_app Mix.Project.config()[:app]

  def migrate do
    :ok = load_app()

    for repo <- fetch_repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    :ok = load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp fetch_repos do
    Application.fetch_env!(@otp_app, :ecto_repos)
  end

  defp load_app do
    Application.load(@otp_app)
  end
end

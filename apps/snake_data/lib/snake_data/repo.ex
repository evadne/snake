defmodule SnakeData.Repo do
  @otp_app Mix.Project.config()[:app]
  use Ecto.Repo, otp_app: @otp_app, adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    {:ok, config_from_environment(config)}
  end

  defp config_from_environment(config) do
    config
    |> Keyword.put(:pool_size, get_pool_size())
    |> Keyword.put(:ssl, get_ssl())
    |> Keyword.put(:socket_options, get_socket_options())
    |> Keyword.merge(get_connection_config())
  end

  defp get_connection_config do
    if url = System.get_env("DATABASE_URL") do
      [url: url]
    else
      {:ok, database} = System.fetch_env("DATABASE_NAME")
      {:ok, username} = System.fetch_env("DATABASE_USERNAME")
      {:ok, password} = System.fetch_env("DATABASE_PASSWORD")
      {:ok, hostname} = System.fetch_env("DATABASE_HOST")
      {:ok, port} = System.fetch_env("DATABASE_PORT")
      [database: database, username: username, password: password, hostname: hostname, port: port]
    end
  end

  defp get_pool_size do
    case System.fetch_env("DATABASE_POOL_SIZE") do
      {:ok, value} -> String.to_integer(value)
      :error -> 10
    end
  end

  defp get_socket_options do
    case System.fetch_env("DATABASE_IPV6") do
      {:ok, "1"} -> [:inet6]
      :error -> []
    end
  end

  defp get_ssl do
    case System.fetch_env("DATABASE_SSL") do
      {:ok, "1"} -> true
      :error -> false
    end
  end
end

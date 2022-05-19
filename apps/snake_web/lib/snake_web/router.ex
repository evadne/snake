defmodule SnakeWeb.Router do
  use SnakeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SnakeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SnakeWeb do
    pipe_through :browser
    get "/", PageController, :index

    live_session :game do
      live "/snakes/new", SnakeLive, :new
      live "/snakes/:id", SnakeLive, :show
    end
  end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through :browser

    live_dashboard "/dashboard",
      ecto_repos: [SnakeData.Repo],
      ecto_psql_extras_options: [long_running_queries: [threshold: "200 milliseconds"]],
      metrics: SnakeWeb.Telemetry
  end
end

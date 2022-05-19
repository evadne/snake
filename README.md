# Multi-Snake

The Multi-Snake project was created to support the talk [Processes & Grains A Journey in Orleans](https://codesync.global/speaker/evadne-wu/) at [Code BEAM Europe 2022](https://codesync.global/conferences/code-beam-sto-2022/) on 19 May 2022.

A copy of the deck can be found [here](https://speakerdeck.com/evadne/processes-grains-8822ac85-5e67-427c-9186-b9d8baf2d494).

A deployed version on Fly.io is available at [https://snake-web.fly.dev](https://snake-web.fly.dev).

## Running the Code

To run the code:

1. Clone the repository.
2. Install the appropriate Erlang, Elixir and Node.js verisons via asdf (see `.tool-versions`).
3. Run `mix deps.get`.
4. Run `mix ecto.setup`.
5. Run `./bin/run`.
6. Visit `https://localhost:4000`.
7. For additional nodes, run `./bin/console`.

## Structure

The Multi-Snake application is an umbrella application with the following applications:

- `snake`: Holds the core game logic and backends.
- `snake_data`: Holds Ecto Repo and all migrations.
- `snake_environment`: Holds clustering and endpoint configuration logic.
- `snake_proxy`: Holds a connection proxy allowing numerous Phoenix apps to be hooked.
- `snake_web`: Holds the main Web application containing a LiveView interface.

## Configuration

Within `apps/snake/config/config.exs`, the appropriate Backend can be selected:

    config :snake,
      backend_module: Snake.Game.Backend.HordeStatem 

Where 3 distinct backends are available:

- `Snake.Game.Backend.ErleansGrain`
- `Snake.Game.Backend.HordeServer`
- `Snake.Game.Backend.HordeStatem`

## Deployment Notes (Fly.io)

### Database Migration

Via Prepared Script:

    $ flyctl ssh console
    > /app/migrate.sh

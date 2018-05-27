# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tomato_tracker,
  ecto_repos: [TomatoTracker.Repo]

# Configures the endpoint
config :tomato_tracker, TomatoTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "f06Aoj6rXeAQGYGd8Kcy0aCVf7JvETu+jDPOk582wHkmc/O1ew4x8aNnv58K6R9V",
  render_errors: [view: TomatoTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TomatoTracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

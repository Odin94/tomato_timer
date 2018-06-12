# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :tomato_tracker, TomatoTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AdfXy7So1mprVeQLIjLWvKILLaPKGGgG1YAEa2oMNyveSD5lYPfJTQGvQDh28mjU",
  render_errors: [view: TomatoTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TomatoTracker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures persistent_storage's tables (each table is one file)
config :persistent_storage,
  tables: [
    config: [path: "./storage/config"],
    data: [path: "./storage/data"]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

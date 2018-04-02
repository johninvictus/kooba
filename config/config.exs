# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kooba_server, ecto_repos: [KoobaServer.Repo]

# Configures the endpoint
config :kooba_server, KoobaServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "A30ZUU/SRa8Yzowm/sxF+A8/WL2LIHnGNCizU1o5e5AirJ20lLX57MmXz22wiJfI",
  render_errors: [view: KoobaServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: KoobaServer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :kooba_server, :facebook_account_kit,
  app_secret: "e2bb65762d42386629bb47838c7a2ded",
  facebook_app_id: "588042518246985"


  # scheduler
  config :kooba_server, KoobaServer.Schedulers,
  jobs: [
     {"* * * * *", {KoobaServer.Schedulers, :send, []}}
  ]

  config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "exq",
  concurrency: 500,
  queues: ["notification"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

defmodule KoobaServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kooba_server,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {KoobaServer.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :httpoison,
        :timex,
        :exq,
        :exq_ui,
        :scrivener_ecto
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:guardian, "~> 1.0"},
      {:cors_plug, "~> 1.5"},
      {:timex, "~> 3.1"},
      {:quantum, "~> 2.2"},
      {:exq, "~> 0.10.1"},
      {:exq_ui, "~> 0.9.0"},
      {:httpotion, "~> 3.1.0"},
      {:elixir_xml_to_map, "~> 0.1"},
      {:fcmex, "~> 0.1.2"},
      {:scrivener_ecto, "~> 1.0"},
      {:scrivener_headers, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

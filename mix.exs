defmodule HelloEts.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_ets,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HelloEts.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cubdb, "~> 1.0"},
      {:cachex, "~> 3.4"},
      {:ets, "~> 0.8"},
      {:stash, "~> 1.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end

defmodule Routekut.MixProject do
  use Mix.Project

  def project do
    [
      app: :routekut,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cidr, github: "alisinabh/cidr-elixir"},
      # TODO: Replace with hex when published by c-rack
      {:httpoison, "~> 1.6"},
      {:stream_gzip, "~> 0.4"}
    ]
  end
end

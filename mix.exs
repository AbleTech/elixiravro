defmodule Elixiravro.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixiravro,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:erlavro]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:erlavro, "~> 2.3.0"},
      {:poison, "~> 3.1"},
    ]
  end
end

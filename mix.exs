defmodule NamedFn.MixProject do
  use Mix.Project

  def project do
    [
      app: :named_fn,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "NamedFn",
      description: "Named function for Elixir.",
      source_url: "https://github.com/Kabie/named_fn",
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ast_walk, "~> 0.3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Kabie/named_fn"}
    ]
  end
end

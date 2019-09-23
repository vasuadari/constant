defmodule Constant.MixProject do
  use Mix.Project

  @github_url "https://github.com/vasuadari/constant"
  @version "0.0.1"

  def project do
    [
      app: :constant,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      maintainers: ["Vasu Adari"],
      deps: deps(),
      name: "constant",
      docs: docs(),
      source_url: @github_url
    ]
  end

  defp description do
    "A package to create constants in elixir modules."
  end

  defp package do
    [
      name: "constant",
      licences: ["MIT"],
      links: %{"Github" => @github_url}
    ]
  end

  defp docs do
    [
      main: "Constant",
      source_ref: "v#{@version}",
      extras: ["README.md"]
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
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end

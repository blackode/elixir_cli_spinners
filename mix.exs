defmodule CliSpinners.Mixfile do
  use Mix.Project

  def project do
    [app: :cli_spinners,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package(),
   ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, github: "elixir-lang/ex_doc", override: true, only: :dev}
    ]
  end

  defp description do
    """
    This module compirises of the loading animations for the CLI - command line interface.   
    This comprises of 60+ loading animations.      
    This is highly useful ind command line applications for loading animations.
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["blackode"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/blackode/cli_spinners",
              "Docs" => "http://hexdocs.pm/cli_spinners/",
              "Creator" => "http://www.blackode.in"}
     ]
  end
end

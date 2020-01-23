defmodule Example.MixProject do
  use Mix.Project

  @all_targets [:rpi, :rpi2, :rpi3, :rpi3a, :rpi0, :bbb, :x86_64]

  @app :example

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Example.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.5", runtime: false},
      {:shoehorn, "~> 0.6.0"},
      {:nerves_hub, path: "../"},
      {:nerves_runtime, "~> 0.10"},
      {:nerves_init_gadget, "~> 0.7", targets: @all_targets},
      {:nerves_time, "~> 0.2", targets: @all_targets},
      {:toolshed, "~> 0.2"},

      {:nerves_system_rpi, "~> 1.8", targets: :rpi, runtime: false},
      {:nerves_system_rpi0, "~> 1.8", targets: :rpi0, runtime: false},
      {:nerves_system_rpi2, "~> 1.8", targets: :rpi2, runtime: false},
      {:nerves_system_rpi3, "~> 1.8", targets: :rpi3, runtime: false},
      {:nerves_system_rpi3a, "~> 1.8", targets: :rpi3a, runtime: false},
      {:nerves_system_bbb, "~> 2.3", targets: :bbb, runtime: false},
      {:nerves_system_x86_64, "~> 1.8", targets: :x86_64, runtime: false},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end

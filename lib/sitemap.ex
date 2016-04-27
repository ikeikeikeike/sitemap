defmodule Sitemap do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Sitemap.Config.configure
    cfg = Sitemap.Config.get

    children = [
      worker(Sitemap.Builders.File, []),
      worker(Sitemap.Builders.Indexfile, []),
      worker(Sitemap.Location, [:file,      [filename: cfg.filename]], id: :location_file),
      worker(Sitemap.Namer,    [:indexfile, [filename: cfg.filename]], id: :namer_indexfile),
      worker(Sitemap.Location, [:indexfile, [filename: cfg.filename]], id: :location_indexfile),
      worker(Sitemap.Namer,    [:file,      [filename: cfg.filename, zero: 1, start: 2]], id: :namer_file),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sitemap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_link, do: start(nil, [])

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Sitemap.DSL
    end
  end



end

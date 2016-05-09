defmodule Sitemap do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Sitemap.Config, [], restart: :transient),
      worker(Sitemap.Builders.File, [], restart: :permanent),
      worker(Sitemap.Builders.Indexfile, [], restart: :permanent),
      worker(Sitemap.Namer, [:indexfile], id: :namer_indexfile, restart: :permanent),
      worker(Sitemap.Namer, [:file, [zero: 1, start: 2]], id: :namer_file, restart: :permanent),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Sitemap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc false
  defmacro __using__(opts) do
    quote do
      use Sitemap.DSL, unquote(opts)
    end
  end

end

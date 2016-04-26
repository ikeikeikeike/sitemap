defmodule Sitemap do
  use Application
  alias Sitemap.Config

  def start_link, do: start(nil, [])
  def start(_type, _args) do
    Config.configure
    cfg = Config.get

    Sitemap.Builders.File.init
    Sitemap.Builders.Indexfile.init
    Sitemap.Location.init(:file, filename: cfg.filename, zero: 1, start: 2)
    Sitemap.Location.init(:indexfile, filename: cfg.filename)
  end

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Sitemap.DSL
    end
  end

end

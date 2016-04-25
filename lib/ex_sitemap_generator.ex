defmodule ExSitemapGenerator do
  use Application
  alias ExSitemapGenerator.Config

  def start_link, do: start(nil, [])
  def start(_type, _args) do
    Config.configure
    cfg = Config.get

    ExSitemapGenerator.Builders.File.init
    ExSitemapGenerator.Builders.Indexfile.init
    ExSitemapGenerator.Location.init(:file, filename: cfg.filename, zero: 1, start: 2)
    ExSitemapGenerator.Location.init(:indexfile, filename: cfg.filename)
  end

  @doc false
  defmacro __using__(_opts) do
    quote do
      use ExSitemapGenerator.DSL
    end
  end

end

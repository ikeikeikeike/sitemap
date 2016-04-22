defmodule ExSitemapGenerator do
  use Application

  def start_link, do: start(nil, [])
  def start(_type, _args) do
    ExSitemapGenerator.Config.configure
    ExSitemapGenerator.Builders.File.init
    ExSitemapGenerator.Builders.Indexfile.init
  end

  @doc false
  defmacro __using__(_opts) do
    quote do
      use ExSitemapGenerator.DSL
    end
  end

end

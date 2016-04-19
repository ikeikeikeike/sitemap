defmodule ExSitemapGenerator do
  use Application

  def start_link, do: start(nil, [])
  def start(_type, _args) do
    ExSitemapGenerator.Config.configure
    ExSitemapGenerator.Builders.File.start_link
    ExSitemapGenerator.Builders.Indexfile.start_link
  end

  @doc false
  defmacro __using__(opts) do
    quote do
      use ExSitemapGenerator.Config, unquote(opts)
      use ExSitemapGenerator.DSL
    end
  end

end

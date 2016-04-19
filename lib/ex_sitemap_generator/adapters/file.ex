defmodule ExSitemapGenerator.Adapters.File do
  alias ExSitemapGenerator.Location

  def write(name, data) do
    Location.directory
  end

end

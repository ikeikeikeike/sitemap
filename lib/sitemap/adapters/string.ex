defmodule Sitemap.Adapters.String do
  alias Sitemap.Location

  def write(name, data) do
    path = Location.path(name)
    if Regex.match?(~r/.gz$/, path) do
      writefile(StringIO.open!(path, [:write, :compressed]), data)
    else
      writefile(StringIO.open!(path, [:write]), data)
    end
  end

  defp writefile(stream, data) do
    IO.write stream, data
    StringIO.close stream
  end

end

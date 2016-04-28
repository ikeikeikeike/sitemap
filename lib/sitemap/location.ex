defmodule Sitemap.Location do
  alias Sitemap.Namer
  alias Sitemap.Config

  def directory(_name), do: directory
  def directory do
    Config.get.files_path
    |> Path.expand
  end

  def path(name) do
    Config.get.files_path
    |> Path.join(filename(name))
    |> Path.expand
  end

  def url(name) do
    s = Config.get
    s.host
    |> Path.join(s.public_path)
    |> Path.join(filename(name))
  end

  def filename(name) do
    fname = Namer.to_string(name)

    s = Config.get
    unless s.compress,
      do: fname = Regex.replace(~r/\.gz$/, fname, "")

    fname
  end

  def reserve_name(name) do
    fname = filename(name)
    Namer.next(name)
    fname
  end

  def write(name, data, _count) do
    s = Config.get
    s.adapter.write(name, data)
  end

end

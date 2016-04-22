defmodule ExSitemapGenerator.Location do
  alias ExSitemapGenerator.Namer
  alias ExSitemapGenerator.Adapters.File, as: FileAdapter

  defstruct [
    adapter: FileAdapter,
    public_path: "",
    filename: "sitemap",
    sitemaps_path: "sitemaps/",
    host: "http://www.example.com",
    verbose: true,
    compress: true,
    create_index: :auto
  ]

  use ExSitemapGenerator.State

  def init(name) do
    Namer.init(name)
    start_link(name)
  end

  def directory(name) do
    s = state(name)
    s.public_path
    |> Path.join(s.sitemaps_path)
    |> Path.expand
  end

  def path(name) do
    s = state(name)
    s.public_path
    |> Path.join(s.sitemaps_path)
    |> Path.join(s.filename)
    |> Path.expand
  end

  def url(name) do
    s = state(name)
    s.host
    |> Path.join(s.sitemaps_path)
    |> Path.join(s.filename)
  end

  def filename(name) do
    s = state(name)

    if Blank.blank?(s.filename) do
      update_state name, :filename, Namer.to_string

      unless s.compress do
        update_state name, :filename, Regex.replace(~r/\.gz$/, s.filename, "")
      end
    end

    s.filename
  end

  def reserve_name(name) do
    filename(name)
    Namer.next
  end

  def write(name, data, _count) do
    reserve_name(name)

    s = state(name)
    s.adapter.write(name, data)
  end

end

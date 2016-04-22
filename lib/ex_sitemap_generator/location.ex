defmodule ExSitemapGenerator.Location do
  alias ExSitemapGenerator.Namer
  alias ExSitemapGenerator.Adapters.File, as: FileAdapter

  defstruct [
    adapter: FileAdapter,
    public_path: "",
    filename: "sitemap",
    sitemaps_path: "sitemaps/",
    host: "http://www.example.com",
    namer: Namer,
    verbose: true,
    compress: true,
    create_index: :auto
  ]

  defp namestate(name),
    do: String.to_atom(Enum.join([__MODULE__, name]))

  def state(name), do: Agent.get(namestate(name), &(&1))

  def start_link(name) do
    Agent.start_link(fn -> %__MODULE__{} end, name: namestate(name))
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

  def reserve_name do

  end

  def write(name, data, _count) do
    s = state(name)
    s.adapter.write(name, data)
  end

end

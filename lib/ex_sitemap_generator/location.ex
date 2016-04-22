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

  def init(name) do
    Namer.init
    start_link(name)
  end

  defp namestate(name),
    do: String.to_atom(Enum.join([__MODULE__, name]))

  def state(name), do: Agent.get(namestate(name), &(&1))

  def start_link(name) do
    Agent.start_link(fn -> %__MODULE__{} end, name: namestate(name))
  end

  def update_state(name, key, xml) do
    Agent.update(namestate(name), fn s ->
      Map.update!(s, key, fn _ -> xml end)
    end)
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
    require IEx; IEx.pry
    s = state(name)

    if Blank.blank?(s.filename) do
      update_state name, :filename, Namer.to_string

      unless s.compress do
        update_state name, :filename, Regex.replace(~r/\.gz$/, s.filename, "")
      end
    end

    require IEx; IEx.pry
    s.filename
  end

  def reserve_name(name) do
    require IEx; IEx.pry
    filename(name)
    Namer.next
    require IEx; IEx.pry
  end

  def write(name, data, _count) do
    require IEx; IEx.pry
    reserve_name(name)

    s = state(name)
    s.adapter.write(name, data)
  end

end

defmodule ExSitemapGenerator.Location do

  defstruct [
    adapter: ExSitemapGenerator.Adapter.File,
    public_path: "",
    filename: "sitemap",
    sitemaps_path: "sitemaps/",
    host: "http://www.example.com",
    namer: ExSitemapGenerator.Namer,
    verbose: true,
    compress: true,
    create_index: :auto
  ]

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, &(&1))
  end

  defp add_content(xml) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, :content, &(&1 <> xml))
    end)
  end

  defp incr_count(key) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 + 1))
    end)
  end


end

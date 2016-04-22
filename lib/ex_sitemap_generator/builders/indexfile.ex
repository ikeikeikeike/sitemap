defmodule ExSitemapGenerator.Builders.Indexfile do
  alias ExSitemapGenerator.Builders.File, as: FileBuilder
  alias ExSitemapGenerator.Builders.Indexurl
  alias ExSitemapGenerator.Location
  require XmlBuilder

  defstruct [
    content: "",
    link_count: 0,
    total_count: 0,
  ]

  def init do
    Location.start_link(:indexfile)
    start_link
  end

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, &(&1))
  end

  defp add_state(key, xml) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 <> xml))
    end)
  end

  defp incr_state(key), do: incr_state(key, 1)
  defp incr_state(key, number) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 + number))
    end)
  end

  def add(options \\ []) do
    FileBuilder.write

    content =
      Indexurl.to_xml(Location.url(:file), options)
      |> XmlBuilder.generate

    add_state :content, content
    incr_state :link_count
    incr_state :total_count, FileBuilder.state.link_count
  end

  def write do
    s = state
    content = Consts.xml_idxheader <> s.content <> Consts.xml_idxfooter
    Location.write :indexfile, content, s.link_count
  end

end

defmodule ExSitemapGenerator.Builders.Indexfile do
  alias ExSitemapGenerator.Builders.Indexurl
  require XmlBuilder

  defstruct location: nil, link_count: 0, total_count: 0, content: ""

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  @doc """
  Get state
  """
  def state do
    Agent.get(__MODULE__, &(&1))
  end

  defp add_content(xml) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, :content, &(&1 <> xml))
    end)
  end

  defp incr_count(key), do: incr_count(key, 1)
  defp incr_count(key, number) do
    Agent.update(__MODULE__, fn s ->
      Map.update!(s, key, &(&1 + number))
    end)
  end

  def add(file, options \\ []) do
    file.write
    fs = file.state

    Indexurl.to_xml(fs.location, options)
    |> XmlBuilder.generate
    |> add_content

    incr_count :link_count
    incr_count :total_count, fs.link_count
  end

  def write do
    s = state
    content = Consts.xml_header <> s.content <> Consts.xml_footer

    s.location.write content, s.link_count
  end

end

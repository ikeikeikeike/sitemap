defmodule ExSitemapGenerator.Builders.File do

  alias ExSitemapGenerator.Builders.Url
  require XmlBuilder

  defstruct location: nil, link_count: 0, news_count: 0, xml_content: ""

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  @doc """
  Get state
  """
  def get do
    Agent.get(__MODULE__, &(&1))
  end

  def addcontent(xml) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, :xml_content, &(&1 <> xml))
    end)
  end

  def incrcount(key) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, key, &(&1 + 1))
    end)
  end

  def add(link, options \\ []) do
    link
    |> Url.to_xml(options)
    |> XmlBuilder.generate
    |> addcontent

    incrcount :link_count

    :ok
  end

end

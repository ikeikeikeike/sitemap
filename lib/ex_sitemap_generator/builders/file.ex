defmodule ExSitemapGenerator.Builders.File do

  defstruct location: nil, link_count: 0, news_count: 0, xml_content: ""

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  @doc """
  Get state
  """
  def get do
    Agent.get(__MODULE__, fn config -> config end)
  end

  def set(key, value) do
    Agent.update(__MODULE__, fn config ->
      Map.update!(config, key, fn _ -> value end)
    end)
  end

  def add(link, options \\ []) do
    xml = Url.to_xml(link, options)
  end

end

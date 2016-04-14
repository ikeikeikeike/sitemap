defmodule ExSitemapGenerator.Builders.Indexfile do
  alias ExSitemapGenerator.Builders.Indexurl
  require XmlBuilder

  defstruct location: nil, link_count: 0, news_count: 0, content: ""

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  @doc """
  Get state
  """
  def get do
    Agent.get(__MODULE__, &(&1))
  end

  defp add_content(xml) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, :content, &(&1 <> xml))
    end)
  end

  defp incr_count(key) do
    Agent.update(__MODULE__, fn state ->
      Map.update!(state, key, &(&1 + 1))
    end)
  end

end

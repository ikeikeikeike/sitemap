defmodule ExSitemapGenerator.Builders.File do
  alias ExSitemapGenerator.Consts
  alias ExSitemapGenerator.Config
  alias ExSitemapGenerator.Builders.Url
  alias ExSitemapGenerator.Location

  require XmlBuilder

  defstruct [
    content: "",
    link_count: 0,
    news_count: 0,
  ]

  def init do
    Location.start_link(:file)
    start_link
  end

  def start_link do
    Agent.start_link(fn -> %__MODULE__{} end, name: __MODULE__)
  end

  def finalize do
    Agent.update(__MODULE__, fn _ ->
      %__MODULE__{}
    end)
  end

  def state, do: Agent.get(__MODULE__, &(&1))

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

  defp sizelimit?(content) do
    s = state

    cfg = Config.get
    r = String.length(s.content <> content) < cfg.max_sitemap_filesize
    r = r && s.link_count < cfg.max_sitemap_links
    r = r && s.news_count < cfg.max_sitemap_news
    r
  end

  def add(link, attrs \\ []) do
    content =
      Url.to_xml(link, attrs)
      |> XmlBuilder.generate

    case sizelimit?(content) do
      false ->
        :full
      true ->
        add_state :content, content
        incr_state :link_count
    end
  end

  def write do
    s = state
    content = Consts.xml_header <> s.content <> Consts.xml_footer
    Location.write :file, content, s.link_count
  end

end

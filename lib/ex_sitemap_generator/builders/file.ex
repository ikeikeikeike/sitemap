defmodule ExSitemapGenerator.Builders.File do
  alias ExSitemapGenerator.Consts
  alias ExSitemapGenerator.Config
  alias ExSitemapGenerator.Builders.Url
  alias ExSitemapGenerator.Location
  require XmlBuilder

  use ExSitemapGenerator.State, [
    content: "",
    link_count: 0,
    news_count: 0,
  ]

  def init do
    start_link
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

    Location.reserve_name(:file)
    Location.write :file, content, s.link_count
  end

end

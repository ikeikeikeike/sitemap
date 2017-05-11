defmodule Sitemap.Builders.File do
  alias Sitemap.Consts
  alias Sitemap.Config
  alias Sitemap.Builders.Url
  alias Sitemap.Location
  require XmlBuilder

  use Sitemap.State, [
    link_count: 0,
    news_count: 0,
    content: "",
    content_size: 0,
  ]

  def sizelimit?(content) do
    size = byte_size(content)
    incr_state :content_size, size

    cfg = Config.get
    s = state()

    r = (size + s.content_size) < cfg.max_sitemap_filesize
    r = r && s.link_count < cfg.max_sitemap_links
    r = r && s.news_count < cfg.max_sitemap_news
    r
  end

  def add(link, attrs \\ []) do
    content =
      Url.to_xml(link, attrs)
      |> XmlBuilder.generate

    if sizelimit?(content) do
      add_state :content, content
      incr_state :link_count
    else
      :full
    end
  end

  def write do
    s = state()
    content = Consts.xml_header <> s.content <> Consts.xml_footer

    Location.reserve_name(:file)
    Location.write :file, content, s.link_count
  end

end

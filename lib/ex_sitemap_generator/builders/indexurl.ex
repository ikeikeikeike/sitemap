defmodule ExSitemapGenerator.Builders.Indexurl do
  alias ExSitemapGenerator.Util
  import XmlBuilder

  def to_xml(link, opts \\ []) do
    element(:sitemap, [
      element(:loc,     link),
      element(:lastmod, Keyword.get_lazy(opts, :lastmod, fn ->
        Util.iso8601
      end))
    ])
  end

end

defmodule ExSitemapGenerator.Builders.Indexurl do
  alias ExSitemapGenerator.Funcs
  import XmlBuilder

  def to_xml(link, opts \\ []) do
    element(:sitemap, Funcs.eraser([
      element(:loc,     link),
      element(:lastmod, Keyword.get_lazy(opts, :lastmod, fn -> Funcs.iso8601 end))
    ]))
  end

end

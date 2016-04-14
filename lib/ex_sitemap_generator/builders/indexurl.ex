defmodule ExSitemapGenerator.Builders.Indexurl do
  import XmlBuilder

  def to_xml(link, opts \\ []) do
    element(:sitemap, [
      element(:loc,     link),
      element(:lastmod, Keyword.get_lazy(opts, :lastmod, fn ->
        # TODO:
        1
      end))
    ])
  end

end

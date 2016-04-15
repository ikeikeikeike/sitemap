defmodule ExSitemapGenerator.Consts do
  import ExSitemapGenerator.Define

  define :max_sitemap_files,    50_000        # max sitemap links per index file
  define :max_sitemap_links,    50_000        # max links per sitemap
  define :max_sitemap_images,   1_000         # max images per url
  define :max_sitemap_news,     1_000         # max news sitemap per index_file
  define :max_sitemap_filesize, 10_000_000    # bytes
  define :schemas, %{
    geo:     "http://www.google.com/geo/schemas/sitemap/1.0",
    image:   "http://www.google.com/schemas/sitemap-image/1.1",
    mobile:  "http://www.google.com/schemas/sitemap-mobile/1.0",
    news:    "http://www.google.com/schemas/sitemap-news/0.9",
    pagemap: "http://www.google.com/schemas/sitemap-pagemap/1.0",
    video:   "http://www.google.com/schemas/sitemap-video/1.1"
  }
  define :xml_header, """
<?xml version="1.0" encoding="UTF-8"?>
  <urlset
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
    xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
      http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
    xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'
    xmlns:geo='http://www.google.com/geo/schemas/sitemap/1.0'
    xmlns:image='http://www.google.com/schemas/sitemap-image/1.1'
    xmlns:mobile='http://www.google.com/schemas/sitemap-mobile/1.0'
    xmlns:news='http://www.google.com/schemas/sitemap-news/0.9'
    xmlns:pagemap='http://www.google.com/schemas/sitemap-pagemap/1.0'
    xmlns:video='http://www.google.com/schemas/sitemap-video/1.1'
    xmlns:xhtml='http://www.w3.org/1999/xhtml'
  >
  """
  define :xml_footer, "</urlset>"

end

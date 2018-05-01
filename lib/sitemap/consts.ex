defmodule Sitemap.Consts do
  import Sitemap.Define

  define :schemas, %{
    geo:     "http://www.google.com/geo/schemas/sitemap/1.0",
    news:    "http://www.google.com/schemas/sitemap-news/0.9",
    image:   "http://www.google.com/schemas/sitemap-image/1.1",
    video:   "http://www.google.com/schemas/sitemap-video/1.1",
    mobile:  "http://www.google.com/schemas/sitemap-mobile/1.0",
    pagemap: "http://www.google.com/schemas/sitemap-pagemap/1.0",
  }

  define :xml_header, """
  <?xml version="1.0" encoding="UTF-8"?>
  <urlset
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
    xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
      http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
    xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'
    xmlns:geo='http://www.google.com/geo/schemas/sitemap/1.0'
    xmlns:news='http://www.google.com/schemas/sitemap-news/0.9'
    xmlns:image='http://www.google.com/schemas/sitemap-image/1.1'
    xmlns:video='http://www.google.com/schemas/sitemap-video/1.1'
    xmlns:mobile='http://www.google.com/schemas/sitemap-mobile/1.0'
    xmlns:pagemap='http://www.google.com/schemas/sitemap-pagemap/1.0'
    xmlns:xhtml='http://www.w3.org/1999/xhtml'
  >
  """
  define :xml_footer, "</urlset>"

  define :xml_idxheader, """
  <?xml version="1.0" encoding="UTF-8"?>
  <sitemapindex
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
      http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd"
    xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  >
  """
  define :xml_idxfooter, "</sitemapindex>"

end

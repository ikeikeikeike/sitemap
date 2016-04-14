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

end

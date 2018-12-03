Code.require_file("../../test_helper.exs", __ENV__.file)

defmodule Sitemap.SitemapTest do
  use ExUnit.Case
  # , max_sitemap_links: 5
  use Sitemap

  setup do
    Sitemap.Builders.File.finalize_state()
    Sitemap.Builders.Indexfile.finalize_state()
    Sitemap.Namer.finalize_state(:file)
    Sitemap.Namer.finalize_state(:indexfile)

    on_exit(fn ->
      nil
    end)

    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "limit file: gen 100 rows" do
    create do
      Sitemap.Config.update(public_path: "")

      Enum.each(1..20, fn n ->
        add("rss#{n}", priority: 0.1, changefreq: "weekly", expires: nil, mobile: true)
        add("site#{n}", priority: 0.2, changefreq: "always", expires: nil, mobile: true)
        add("entry#{n}", priority: 0.3, changefreq: "dayly", expires: nil, mobile: false)
        add("about#{n}", priority: 0.4, changefreq: "monthly", expires: nil, mobile: true)
        add("contact#{n}", priority: 0.5, changefreq: "yearly", expires: nil, mobile: false)
      end)
    end
  end

  test "full example" do
    create do
      add("index.html",
        news: [
          publication_name: "Example",
          publication_language: "en",
          title: "My Article",
          keywords: "my article, articles about myself",
          stock_tickers: "SAO:PETR3",
          publication_date: "2011-08-22",
          access: "Subscription",
          genres: "PressRelease"
        ]
      )

      add("index.html",
        videos: [
          thumbnail_loc: "Example",
          publication_language: "http://www.example.com/video1_thumbnail.png",
          title: "My Video",
          description: "my video, videos about itself",
          content_loc: "http://www.example.com/cool_video.mpg",
          tags: ~w(and then nothing),
          category: "Category"
        ]
      )
    end
  end
end

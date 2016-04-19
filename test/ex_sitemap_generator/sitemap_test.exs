Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.SitemapTest do
  use ExUnit.Case
  use ExSitemapGenerator, max_sitemap_links: 5

  setup do
    ExSitemapGenerator.start_link
    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "limit file" do
    create do
      IO.inspect ExSitemapGenerator.Config.get

      Enum.each 0..10, fn n ->
        add "rss#{n}",     priority: 0.1, changefreq: "weekly", lastmod: nil, mobile: true
        add "site#{n}",    priority: 0.2, changefreq: "always", lastmod: nil, mobile: true
        add "entry#{n}",   priority: 0.3, changefreq: "dayly", lastmod: nil, mobile: false
        add "about#{n}",   priority: 0.4, changefreq: "monthly", lastmod: nil, mobile: true
        add "contact#{n}", priority: 0.5, changefreq: "yearly", lastmod: nil, mobile: false
      end
    end
  end

end

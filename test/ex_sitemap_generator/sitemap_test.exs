Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.SitemapTest do
  use ExUnit.Case
  use ExSitemapGenerator#, max_sitemap_links: 5

  alias ExSitemapGenerator.Config

  setup do
    ExSitemapGenerator.start_link
    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "limit file" do
    Config.set :max_sitemap_links, 10

    create do
      Enum.each 0..20, fn n ->
        add "rss#{n}",     priority: 0.1, changefreq: "weekly",  expires: nil, mobile: true
        add "site#{n}",    priority: 0.2, changefreq: "always",  expires: nil, mobile: true
        add "entry#{n}",   priority: 0.3, changefreq: "dayly",   expires: nil, mobile: false
        add "about#{n}",   priority: 0.4, changefreq: "monthly", expires: nil, mobile: true
        add "contact#{n}", priority: 0.5, changefreq: "yearly",  expires: nil, mobile: false
      end
    end
  end

end

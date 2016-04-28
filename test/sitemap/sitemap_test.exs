Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Sitemap.SitemapTest do
  use ExUnit.Case
  use Sitemap#, max_sitemap_links: 5

  setup do
    Sitemap.Builders.File.finalize_state
    Sitemap.Builders.Indexfile.finalize_state
    Sitemap.Namer.finalize_state :file
    Sitemap.Namer.finalize_state :indexfile

    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "limit file: gen 100 rows" do
    create do
      Sitemap.Config.update public_path: ""

      Enum.each 1..20, fn n ->
        add "rss#{n}",     priority: 0.1, changefreq: "weekly",  expires: nil, mobile: true
        add "site#{n}",    priority: 0.2, changefreq: "always",  expires: nil, mobile: true
        add "entry#{n}",   priority: 0.3, changefreq: "dayly",   expires: nil, mobile: false
        add "about#{n}",   priority: 0.4, changefreq: "monthly", expires: nil, mobile: true
        add "contact#{n}", priority: 0.5, changefreq: "yearly",  expires: nil, mobile: false
      end
    end

    assert Sitemap.Builders.Indexfile.state.total_count == 100
  end

  # test "limit file: gen 1000 rows" do
    # create do
      # Enum.each 1..1000, fn n ->
        # add "rss#{n}",     priority: 0.1, changefreq: "weekly",  expires: nil, mobile: true
        # add "site#{n}",    priority: 0.2, changefreq: "always",  expires: nil, mobile: true
        # add "entry#{n}",   priority: 0.3, changefreq: "dayly",   expires: nil, mobile: false
        # add "about#{n}",   priority: 0.4, changefreq: "monthly", expires: nil, mobile: true
        # add "contact#{n}", priority: 0.5, changefreq: "yearly",  expires: nil, mobile: false
      # end
    # end

    # assert Sitemap.Builders.Indexfile.state.total_count == 1000
  # end

end

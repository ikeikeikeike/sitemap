defmodule Sitemapxml do
  use Sitemap

  def generate do
    create do
      Enum.each 1..20, fn n ->
        add "rss#{n}",     priority: 0.1, changefreq: "weekly",  expires: nil, mobile: true
        add "site#{n}",    priority: 0.2, changefreq: "always",  expires: nil, mobile: true
        add "entry#{n}",   priority: 0.3, changefreq: "dayly",   expires: nil, mobile: false
        add "about#{n}",   priority: 0.4, changefreq: "monthly", expires: nil, mobile: true
        add "contact#{n}", priority: 0.5, changefreq: "yearly",  expires: nil, mobile: false
      end
    end
  end
end

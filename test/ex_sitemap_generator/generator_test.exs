Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.GeneratorTest do

  use ExUnit.Case
  use ExSitemapGenerator

  test "create macro" do
    resp = create do
      false
    end

    assert resp == {:ok, []}
  end

  test "add function" do

    IO.inspect add "rss", priority: nil, changefreq: nil, lastmod: nil, mobile: true
    IO.inspect "kjkjk"
    resp = create do
      ExSitemapGenerator.Generator.add "rss",     priority: nil, changefreq: nil, lastmod: nil, mobile: true
      ExSitemapGenerator.Generator.add "site",    priority: nil, changefreq: nil, lastmod: nil, mobile: true
      ExSitemapGenerator.Generator.add "entry",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      ExSitemapGenerator.Generator.add "about",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      ExSitemapGenerator.Generator.add "contact", priority: nil, changefreq: nil, lastmod: nil, mobile: true
    end

    IO.inspect resp
    # assert add("link", []) == {"link", []}
  end

  # test "add_to_index function" do
    # assert add("link", []) == {"link", []}
  # end

end

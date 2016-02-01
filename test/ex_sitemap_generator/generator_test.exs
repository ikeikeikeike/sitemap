Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.GeneratorTest do

  use ExUnit.Case
  use ExSitemapGenerator

  test "create macro" do
    {:ok, []} == create do
      false
    end
  end

  test "add function" do
    create do
      add "rss",     priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "site",    priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "entry",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "about",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "contact", priority: nil, changefreq: nil, lastmod: nil, mobile: true

      assert add("link", []) == :ok
    end

    assert add("link", []) == :ok
  end

  # test "add_to_index function" do
    # assert add("link", []) == {"link", []}
  # end

end

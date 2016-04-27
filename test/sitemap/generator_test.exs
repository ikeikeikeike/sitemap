Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Sitemap.GeneratorTest do
  use ExUnit.Case
  use Sitemap

  setup do
    Sitemap.Builders.File.finalize_state
    Sitemap.Builders.Indexfile.finalize_state

    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "create macro" do
    statement = create do
      false
    end
    assert {:ok, []} == statement
  end

  test "create & add" do
    create do
      add "rss",     priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "site",    priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "entry",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "about",   priority: nil, changefreq: nil, lastmod: nil, mobile: true
      add "contact", priority: nil, changefreq: nil, lastmod: nil, mobile: true
      assert Sitemap.Builders.File.state.link_count == 5
    end
  end

  test "add_to_index function" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Sitemap.Builders.File.add(data)

    assert :ok == full
  end

end

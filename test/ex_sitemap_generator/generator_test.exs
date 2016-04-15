Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.GeneratorTest do

  use ExUnit.Case
  use ExSitemapGenerator
  alias ExSitemapGenerator.Builders.File

  setup do
    ExSitemapGenerator.start_link
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

      assert add("link", []) == :ok
    end

    assert File.state.link_count == 6
  end

  test "add_to_index function" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    File.add(data)

    assert :ok == add_to_index(File, [])
  end

end

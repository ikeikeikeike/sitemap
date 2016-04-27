Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Sitemap.BuildersFileTest do
  use ExUnit.Case

  setup do
    Sitemap.Builders.File.finalize_state
    Sitemap.Builders.Indexfile.finalize_state

    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Add Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    assert :ok == Sitemap.Builders.File.add(data)
  end

  test "Adds Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Enum.each(1..10, fn _ -> Sitemap.Builders.File.add(data) end)

    assert 10 == Sitemap.Builders.File.state.link_count
  end

  # TODO: Want improving.
  test "content_limit? Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Enum.each(1..100, fn _ -> Sitemap.Builders.File.add(data) end)

    assert :ok == Sitemap.Builders.File.add(data)
    assert 101 == Sitemap.Builders.File.state.link_count
  end

end

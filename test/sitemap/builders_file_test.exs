Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Sitemap.BuildersFileTest do

  use ExUnit.Case
  alias Sitemap.Builders.File

  setup do
    Sitemap.start_link
    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Add Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    assert :ok == File.add(data)
  end

  test "Adds Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Enum.each(1..10, fn _ -> File.add(data) end)

    assert 10 == File.state.link_count
  end

  # TODO: Want improving.
  test "content_limit? Builders.File" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    Enum.each(1..100, fn _ -> File.add(data) end)

    assert :ok == File.add(data)
    assert 101 == File.state.link_count
  end

end

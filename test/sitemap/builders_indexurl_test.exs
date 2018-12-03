Code.require_file("../../test_helper.exs", __ENV__.file)

defmodule Sitemap.BuildersIndexurlTest do
  use ExUnit.Case

  # alias Sitemap.Builders.Indexurl
  # import SweetXml
  # require XmlBuilder

  setup do
    Sitemap.Builders.File.finalize_state()
    Sitemap.Builders.Indexfile.finalize_state()
    Sitemap.Namer.finalize_state(:file)
    Sitemap.Namer.finalize_state(:indexfile)

    on_exit(fn ->
      nil
    end)

    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  # test "Basic sitemap indexurl" do
  # data = [
  # lastmod: "lastmod",
  # expires: "expires",
  # changefreq: "changefreq",
  # priority: 0.5
  # ]
  # actual =
  # Indexurl.to_xml("loc", data)
  # |> XmlBuilder.generate

  # parsed = parse(actual)
  # assert xpath(parsed, ~x"//loc/text()")        == 'loc'
  # assert xpath(parsed, ~x"//lastmod/text()")    == 'lastmod'
  # assert xpath(parsed, ~x"//expires/text()")    == 'expires'
  # assert xpath(parsed, ~x"//changefreq/text()") == 'changefreq'
  # assert xpath(parsed, ~x"//priority/text()")   == '0.5'
  # end
end

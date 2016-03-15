Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.BuildersUrlTest do
  use ExUnit.Case

  alias ExSitemapGenerator.Builders.Url
  require XmlBuilder

  setup do
    ExSitemapGenerator.start_link
    on_exit fn ->
      # IO.puts "done"
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Basic sitemap url" do
    data = [loc: "loc", lastmod: "lastmod", expires: "expires", changefreq: "changefreq", priority: 0.5]
    expected = "<url>\n\t<loc>loc</loc>\n\t<lastmod>lastmod</lastmod>\n\t<expires>expires</expires>\n\t<changefreq>changefreq</changefreq>\n\t<priority>0.5</priority>\n</url>"

    actual =
      data
      |> Url.to_xml
      |> XmlBuilder.generate

    assert actual == expected
  end

  test "News sitemap url" do
    data = [news: [
      publication_name: "Example",
      publication_language: "en",
      title: "My Article",
      keywords: "my article, articles about myself",
      stock_tickers: "SAO:PETR3",
      publication_date: "2011-08-22",
      access: "Subscription",
      genres: "PressRelease"
    ]]
    expected = "<url>\n\t<loc/>\n\t<lastmod/>\n\t<expires/>\n\t<changefreq/>\n\t<priority/>\n\t<news:news>\n\t\t<news:publication>\n\t\t\t<news:name>Example</news:name>\n\t\t\t<news:language>en</news:language>\n\t\t</news:publication>\n\t\t<:news:title>My Article</:news:title>\n\t\t<:news:access>Subscription</:news:access>\n\t\t<:news:genres>PressRelease</:news:genres>\n\t\t<:news:keywords>my article, articles about myself</:news:keywords>\n\t\t<:news:stock_tickers>SAO:PETR3</:news:stock_tickers>\n\t\t<:news:publication_date>2011-08-22</:news:publication_date>\n\t</news:news>\n</url>"

    actual =
      data
      |> Url.to_xml
      |> XmlBuilder.generate

    assert actual == expected
  end

  test "Images sitemap url" do
  end

  test "Videos sitemap url" do
  end

  test "Alternates sitemap url" do
  end

  test "Geo sitemap url" do
  end

  test "Mobile sitemap url" do
  end

  test "Pagemap sitemap url" do
  end


end

Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.BuildersUrlTest do
  use ExUnit.Case

  alias ExSitemapGenerator.Builders.Url
  import SweetXml
  require XmlBuilder

  setup do
    ExSitemapGenerator.start_link
    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Basic sitemap url" do
    data = [
      lastmod: "lastmod",
      expires: "expires",
      changefreq: "changefreq",
      priority: 0.5
    ]
    actual =
      Url.to_xml("loc", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        == 'loc'
    assert xpath(parsed, ~x"//lastmod/text()")    == 'lastmod'
    assert xpath(parsed, ~x"//expires/text()")    == 'expires'
    assert xpath(parsed, ~x"//changefreq/text()") == 'changefreq'
    assert xpath(parsed, ~x"//priority/text()")   == '0.5'
  end

  test "Basic sitemap url with contains nil" do
    data = [
      lastmod: "lastmod",
      expires: nil,
      changefreq: nil,
      priority: 0.5
    ]
    actual =
      Url.to_xml("loc", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        == 'loc'
    assert xpath(parsed, ~x"//lastmod/text()")    == 'lastmod'
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   == '0.5'
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

    actual =
      Url.to_xml(nil, data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        ==  nil
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//news:news/news:publication/news:name/text()") == 'Example'
    assert xpath(parsed, ~x"//news:news/news:publication/news:language/text()") == 'en'
    require IEx; IEx.pry
    assert xpath(parsed, ~x"//news:news/news:title/text()") == 'My Article'
    assert xpath(parsed, ~x"//news:news/news:keywords/text()") == 'my article, articles about myself'
    assert xpath(parsed, ~x"//news:news/news:stock_tickers/text()") == 'SAO:PETR3'
    assert xpath(parsed, ~x"//news:news/news:publication_date/text()") == '2011-08-22'
    assert xpath(parsed, ~x"//news:news/news:genres/text()") == 'PressRelease'
    assert xpath(parsed, ~x"//news:news/news:access/text()") == 'Subscription'
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

Code.require_file "../../test_helper.exs", __ENV__.file

defmodule Sitemap.BuildersUrlTest do
  use ExUnit.Case

  alias Sitemap.Builders.Url
  import SweetXml
  require XmlBuilder

  setup do
    Sitemap.Builders.File.finalize_state
    Sitemap.Builders.Indexfile.finalize_state
    Sitemap.Namer.finalize_state :file
    Sitemap.Namer.finalize_state :indexfile

    on_exit fn ->
      nil
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "Combine Host" do
    actual =
      Url.to_xml("path", [])
      |> XmlBuilder.generate

    assert xpath(parse(actual), ~x"//loc/text()") == 'http://www.example.com/path'
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
    assert xpath(parsed, ~x"//loc/text()")        == 'http://www.example.com/loc'
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
    assert xpath(parsed, ~x"//loc/text()")        == 'http://www.example.com/loc'
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
    assert xpath(parsed, ~x"//loc/text()")        ==  'http://www.example.com'
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//news:news/news:publication/news:name/text()") == 'Example'
    assert xpath(parsed, ~x"//news:news/news:publication/news:language/text()") == 'en'
    assert xpath(parsed, ~x"//news:news/news:title/text()") == 'My Article'
    assert xpath(parsed, ~x"//news:news/news:keywords/text()") == 'my article, articles about myself'
    assert xpath(parsed, ~x"//news:news/news:stock_tickers/text()") == 'SAO:PETR3'
    assert xpath(parsed, ~x"//news:news/news:publication_date/text()") == '2011-08-22'
    assert xpath(parsed, ~x"//news:news/news:genres/text()") == 'PressRelease'
    assert xpath(parsed, ~x"//news:news/news:access/text()") == 'Subscription'
  end

  test "Images sitemap url" do
    data = [images: [
      loc: "http://example.com/image.jpg",
      caption: "Caption",
      title: "Title",
      license: "https://github.com/ikeikeikeike/sitemap/blob/master/LICENSE",
      geo_location: "Limerick, Ireland",
    ]]

    actual =
      Url.to_xml("/image.html", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        ==  'http://www.example.com/image.html'
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//image:image/image:title/text()") == 'Title'
    assert xpath(parsed, ~x"//image:image/image:loc/text()") == 'http://example.com/image.jpg'
    assert xpath(parsed, ~x"//image:image/image:caption/text()") == 'Caption'
    assert xpath(parsed, ~x"//image:image/image:license/text()") == 'https://github.com/ikeikeikeike/sitemap/blob/master/LICENSE'
    assert xpath(parsed, ~x"//image:image/image:geo_location/text()") == 'Limerick, Ireland'
  end

  test "Videos sitemap url" do
    data = [videos: [
      thumbnail_loc: "http://www.example.com/thumbs/123.jpg",
      title: "Grilling steaks for summer",
      description: "Alkis shows you how to get perfectly done steaks every time",
      content_loc: "http://www.example.com/video123.flv",
      player_loc: "http://www.example.com/videoplayer.swf?video=123",
      allow_embed: true,
      autoplay: true,
      duration: 600,
      expiration_date: "2009-11-05T19:20:30+08:00",
    ]]

    actual =
      Url.to_xml("/video.html", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        ==  'http://www.example.com/video.html'
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//video:video/video:title/text()") == 'Grilling steaks for summer'
    assert xpath(parsed, ~x"//video:video/video:thumbnail_loc/text()") == 'http://www.example.com/thumbs/123.jpg'
    assert xpath(parsed, ~x"//video:video/video:description/text()") == 'Alkis shows you how to get perfectly done steaks every time'
    assert xpath(parsed, ~x"//video:video/video:content_loc/text()") == 'http://www.example.com/video123.flv'
    assert xpath(parsed, ~x"//video:video/video:player_loc/text()") == 'http://www.example.com/videoplayer.swf?video=123'
    assert xpath(parsed, ~x"//video:video/video:player_loc/@allow_embed") == 'yes'
    assert xpath(parsed, ~x"//video:video/video:player_loc/@autoplay") == 'ap=1'
    assert xpath(parsed, ~x"//video:video/video:duration/text()") == '600'
    assert xpath(parsed, ~x"//video:video/video:expiration_date/text()") == '2009-11-05T19:20:30+08:00'
  end

  test "Videos sitemap url fully" do
    data = [videos: [
      thumbnail_loc: "http://www.example.com/thumbs/123.jpg",
      title: "Grilling steaks for summer",
      description: "Alkis shows you how to get perfectly done steaks every time",
      content_loc: "http://www.example.com/video123.flv",
      player_loc: "http://www.example.com/videoplayer.swf?video=123",
      allow_embed: true,
      autoplay: true,
      duration: 600,
      expiration_date: "2009-11-05T19:20:30+08:00",
      publication_date: "2007-11-05T19:20:30+08:00",
      rating: 0.5,
      view_count: 1000,
      tags: ~w(tag1 tag2 tag3),
      tag: "tag4",
      category: "Category",
      family_friendly: true,
      restriction: "IE GB US CA",
      relationship: true,
      gallery_loc: "http://cooking.example.com",
      gallery_title: "Cooking Videos",
      price: "1.99",
      price_currency: "EUR",
      price_type: "own",
      price_resolution: "HD",
      uploader: "GrillyMcGrillerson",
      uploader_info: "http://www.example.com/users/grillymcgrillerson",
      live: true,
      requires_subscription: false
    ]]

    actual =
      Url.to_xml("/video.html", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        ==  'http://www.example.com/video.html'
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//video:video/video:title/text()") == 'Grilling steaks for summer'
    assert xpath(parsed, ~x"//video:video/video:thumbnail_loc/text()") == 'http://www.example.com/thumbs/123.jpg'
    assert xpath(parsed, ~x"//video:video/video:description/text()") == 'Alkis shows you how to get perfectly done steaks every time'
    assert xpath(parsed, ~x"//video:video/video:content_loc/text()") == 'http://www.example.com/video123.flv'
    assert xpath(parsed, ~x"//video:video/video:player_loc/text()") == 'http://www.example.com/videoplayer.swf?video=123'
    assert xpath(parsed, ~x"//video:video/video:player_loc/@allow_embed") == 'yes'
    assert xpath(parsed, ~x"//video:video/video:player_loc/@autoplay") == 'ap=1'
    assert xpath(parsed, ~x"//video:video/video:duration/text()") == '600'
    assert xpath(parsed, ~x"//video:video/video:expiration_date/text()") == '2009-11-05T19:20:30+08:00'
    assert xpath(parsed, ~x"//video:video/video:rating/text()") == '0.5'
    assert xpath(parsed, ~x"//video:video/video:view_count/text()") == '1000'
    assert xpath(parsed, ~x"//video:video/video:publication_date/text()") == '2007-11-05T19:20:30+08:00'
    assert xpath(parsed, ~x"//video:video/video:family_friendly/text()") == 'yes'
    assert xpath(parsed, ~x"//video:video/video:restriction/text()") == 'IE GB US CA'
    assert xpath(parsed, ~x"//video:video/video:restriction/@relationship") == 'allow'
    assert xpath(parsed, ~x"//video:video/video:gallery_loc/text()") == 'http://cooking.example.com'
    assert xpath(parsed, ~x"//video:video/video:gallery_loc/@title") == 'Cooking Videos'
    assert xpath(parsed, ~x"//video:video/video:price/text()") == '1.99'
    assert xpath(parsed, ~x"//video:video/video:price/@currency") == 'EUR'
    assert xpath(parsed, ~x"//video:video/video:price/@resolution") == 'HD'
    assert xpath(parsed, ~x"//video:video/video:price/@type") == 'own'
    assert xpath(parsed, ~x"//video:video/video:requires_subscription/text()") == 'no'
    assert xpath(parsed, ~x"//video:video/video:uploader/text()") == 'GrillyMcGrillerson'
    assert xpath(parsed, ~x"//video:video/video:uploader/@info") == 'http://www.example.com/users/grillymcgrillerson'
    assert xpath(parsed, ~x"//video:video/video:live/text()") == 'yes'
  end
  test "Alternates sitemap url" do

    data = ["/index.html", alternates: [
         href: "http://www.example.de/index.html",
         lang: "de",
         nofollow: true,
         media: "only screen and (max-width: 640px)"
    ]]

    actual =
      Url.to_xml("/video.html", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//loc/text()")        ==  'http://www.example.com/video.html'
    assert xpath(parsed, ~x"//lastmod/text()")    !=  nil
    assert xpath(parsed, ~x"//expires/text()")    ==  nil
    assert xpath(parsed, ~x"//changefreq/text()") ==  nil
    assert xpath(parsed, ~x"//priority/text()")   ==  nil

    assert xpath(parsed, ~x"//xhtml:link/@href") == 'http://www.example.de/index.html'
    assert xpath(parsed, ~x"//xhtml:link/@hreflang") == 'de'
    assert xpath(parsed, ~x"//xhtml:link/@media") == 'only screen and (max-width: 640px)'
    assert xpath(parsed, ~x"//xhtml:link/@rel") == 'alternate nofollow'
  end

  test "Geo sitemap url" do
    data = ["/geo.html", geo: [
         format: "kml"
    ]]

    actual =
      Url.to_xml("/geo.html", data)
      |> XmlBuilder.generate

    parsed = parse(actual)
    assert xpath(parsed, ~x"//geo:geo/geo:format/text()") == 'kml'
  end

  test "Mobile sitemap url" do
  end

  test "Pagemap sitemap url" do
  end


end

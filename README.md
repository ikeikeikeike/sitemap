# Sitemap

[![Build Status](http://img.shields.io/travis/ikeikeikeike/sitemap.svg?style=flat-square)](http://travis-ci.org/ikeikeikeike/sitemap)
[![Hex version](https://img.shields.io/hexpm/v/sitemap.svg "Hex version")](https://hex.pm/packages/sitemap)
[![Hex downloads](https://img.shields.io/hexpm/dt/sitemap.svg "Hex downloads")](https://hex.pm/packages/sitemap)
[![Inline docs](https://inch-ci.org/github/ikeikeikeike/sitemap.svg)](http://inch-ci.org/github/ikeikeikeike/sitemap)
[![hex.pm](https://img.shields.io/hexpm/l/ltsv.svg)](https://github.com/ikeikeikeike/sitemap/blob/master/LICENSE)


Generating sitemap.xml


## Installation


If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add sitemap to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:sitemap, ">= 0.0.0"}]
  end
  ```

  2. Ensure sitemap is started before your application:

  ```elixir
  def application do
    [applications: [:sitemap]]
  end
  ```

#### Usage

###### Basic

```elixir
defmodule Sitemaps do
  use Sitemap

  create do
    add "path1", priority: 0.5, changefreq: "hourly", expires: nil, mobile: true
  end

  ping
end
```

###### As a function

```elixir
defmodule Sitemaps do
  use Sitemap

  def generate do
    create do
      add "path1", priority: 0.5, changefreq: "hourly", expires: nil, mobile: true
    end

    ping
  end

end
```

###### With Phoenix

```elixir
defmodule Sitemaps do
  use Sitemap,
    host: "http://#{Application.get_env(:myapp, MyApp.Endpoint)[:url][:host]}",
    files_path: "priv/static/sitemaps/",
    public_path: "sitemaps/"

  alias MyApp.Router.Helpers

  create do
    entries = MyApp.Repo.all MyApp.Entry

    Enum.each [false, true], fn bool ->
      add Helpers.entry_path(MyApp.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

      Enum.each(entries, fn entry ->
        add Helpers.entry_path(MyApp.Endpoint, :show, entry.id, entry.title),
          priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool
      end)

    end
  end

  ping

end
```

#### Change options.


###### Change option( use statement )

```elixir
defmodule Sitemaps do
  use Sitemap, compress: false, host: "http://example.com"

  create do
    add "path1", priority: 0.5, changefreq: "hourly"
    add "path2", priority: 0.5, changefreq: "hourly"
  end

  ping
end
```

###### Change option( create function's option )


```elixir
defmodule Sitemaps do
  use Sitemap

  create compress: false, host: "http://example.com" do
    add "path1", priority: 0.5, changefreq: "hourly"
    add "path2", priority: 0.5, changefreq: "hourly"
  end

  ping
end
```

### Features

Current Features or To-Do

- [x] [Supports: generate kind of some sitemaps](#supports-generate-kind-of-some-sitemaps)
  - [x] [News Sitemaps](#news-sitemaps)
  - [x] [Video Sitemaps](#video-sitemaps)
  - [x] Image Sitemaps
  - [x] Geo Sitemaps
  - [x] Mobile Sitemaps
  - [x] PageMap Sitemap
  - [x] Alternate Links
- [ ] Supports: write some kind of filesystem and object storage.
  - [x] Filesystem
  - [ ] S3
- [x] Customizable sitemap working
- [x] Notifies search engines (Google, Bing) of new sitemaps
- [x] Gives you complete control over your sitemap contents and naming scheme
- [x] Customizable sitemap compression
- [ ] Intelligent sitemap indexing
- [ ] All of completing Examples



## Supports: generate kind of some sitemaps


### News Sitemaps

```elixir
defmodule Sitemaps do
  use Sitemap, compress: false, host: "http://example.com"

  create do
    add "index.html", news: [
         publication_name: "Example",
         publication_language: "en",
         title: "My Article",
         keywords: "my article, articles about myself",
         stock_tickers: "SAO:PETR3",
         publication_date: "2011-08-22",
         access: "Subscription",
         genres: "PressRelease"
       ]
  end
end
```

###### Generated Result

```xml
<url>
 <loc>http://www.example.com/index.html</loc>
 <lastmod>2016-05-30T13:13:12Z</lastmod>
 <news:news>
   <news:publication>
     <news:name>Example</news:name>
     <news:language>en</news:language>
   </news:publication>
   <news:title>My Article</news:title>
   <news:access>Subscription</news:access>
   <news:genres>PressRelease</news:genres>
   <news:keywords>my article, articles about myself</news:keywords>
   <news:stock_tickers>SAO:PETR3</news:stock_tickers>
   <news:publication_date>2011-08-22</news:publication_date>
 </news:news>
</url>
```

Look at [Creating a Google News Sitemap](https://support.google.com/news/publisher/answer/74288) as required.

### Video sitemaps

```elixir
defmodule Sitemaps do
  use Sitemap, compress: true, host: "http://example.com"

  create do
    add "index.html", videos: [
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
       ]
  end
end

```

###### Generated Result

```xml
<url>
 <loc>http://www.example.com/video.html</loc>
 <lastmod>2016-05-31T12:51:47Z</lastmod>
 <video:video>
   <video:title>Grilling steaks for summer</video:title>
   <video:description>Alkis shows you how to get perfectly done steaks every time</video:description>
   <video:player_loc allow_embed="yes" autoplay="ap=1">http://www.example.com/videoplayer.swf?video=123</video:player_loc>
   <video:content_loc>http://www.example.com/video123.flv</video:content_loc>
   <video:thumbnail_loc>http://www.example.com/thumbs/123.jpg</video:thumbnail_loc>
   <video:duration>600</video:duration>
   <video:gallery_loc title="Cooking Videos">http://cooking.example.com</video:gallery_loc>
   <video:rating>0.5</video:rating>
   <video:view_count>1000</video:view_count>
   <video:expiration_date>2009-11-05T19:20:30+08:00</video:expiration_date>
   <video:publication_date>2007-11-05T19:20:30+08:00</video:publication_date>
   <video:tag>tag1</video:tag>
   <video:tag>tag2</video:tag>
   <video:tag>tag3</video:tag>
   <video:tag>tag4</video:tag>
   <video:category>Category</video:category>
   <video:family_friendly>yes</video:family_friendly>
   <video:restriction relationship="allow">IE GB US CA</video:restriction>
   <video:uploader info="http://www.example.com/users/grillymcgrillerson">GrillyMcGrillerson</video:uploader>
   <video:price currency="EUR" resolution="HD" type="own">1.99</video:price>
   <video:live>yes</video:live>
   <video:requires_subscription>no</video:requires_subscription>
 </video:video>
</url>
```

Look at [Video sitemaps](https://developers.google.com/webmasters/videosearch/sitemaps#adding-video-content-to-a-sitemap) as required.

# Sitemap

[![Build Status](http://img.shields.io/travis/ikeikeikeike/sitemap.svg?style=flat-square)](http://travis-ci.org/ikeikeikeike/sitemap)
[![Hex version](https://img.shields.io/hexpm/v/sitemap.svg "Hex version")](https://hex.pm/packages/sitemap)
[![Hex downloads](https://img.shields.io/hexpm/dt/sitemap.svg "Hex downloads")](https://hex.pm/packages/sitemap)
[![Inline docs](https://inch-ci.org/github/ikeikeikeike/sitemap.svg)](http://inch-ci.org/github/ikeikeikeike/sitemap)
[![hex.pm](https://img.shields.io/hexpm/l/ltsv.svg)](https://github.com/ikeikeikeike/sitemap/blob/master/LICENSE)


Generating sitemap.xml


## Installation

`Still developing.`

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
  - [x] Video Sitemaps
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
         thumbnail_loc: "Example",
         publication_language: "http://www.example.com/video1_thumbnail.png",
         title: "My Video",
         description: "my video, videos about itself",
         content_loc: "http://www.example.com/cool_video.mpg",
         tags: ~w(and then nothing),
         category: "Category"
       ]
  end
end

```

###### Generated Result

```xml
<url>
    <loc>http://www.example.com/video.html</loc>
    <lastmod>2016-05-30T14:53:00Z</lastmod>
    <video:video>
        <video:title>Grilling steaks for summer</video:title>
        <video:description>Alkis shows you how to get perfectly done steaks every time</video:description>
        <video:rating>0.5</video:rating>
        <video:duration>600</video:duration>
        <video:view_count>1000</video:view_count>
        <video:expiration_date>2009-11-05T19:20:30+08:00</video:expiration_date>
        <video:publication_date>2007-11-05T19:20:30+08:00</video:publication_date>
        <video:tag>tag1</video:tag>
        <video:tag>tag2</video:tag>
        <video:tag>tag3</video:tag>
        <video:tag>tag4</video:tag>
        <video:category>Category</video:category>
        <video:family_friendly>yes</video:family_friendly>
    </video:video>
</url>
```

Look at [Video sitemaps](https://support.google.com/webmasters/answer/80471) as required.

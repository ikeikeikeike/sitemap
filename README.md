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

###### With Ecto

```elixir
defmodule Sitemaps do
  use Sitemap,
    host: "http://#{Application.get_env(:myapp, MyApp.Endpoint)[:url][:host]}",
    files_path: "priv/static/sitemaps/",
    public_path: "sitemaps/"

  alias MyApp.Router.Helpers

  create do
    entries =
      MyApp.Entry
      |> MyApp.Repo.all

    Enum.each [false, true], fn bool ->
      add Helpers.entry_path(MyApp.Endpoint, :index),
        priority: 0.5, changefreq: "hourly", expires: nil, mobile: bool

      entries
      |> Enum.each(fn entry ->
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
  use Sitemap, compress: false, create_index: true

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

  create compress: false, create_index: true do
    add "path1", priority: 0.5, changefreq: "hourly"
    add "path2", priority: 0.5, changefreq: "hourly"
  end

  ping
end
```

### Features

Current Features or To-Do

- [x] Supports: generate kind of some sitemaps.
  - [x] News sitemaps
  - [x] Video sitemaps
  - [x] Image sitemaps
  - [x] Geo sitemaps
  - [x] Mobile sitemaps
  - [x] PageMap sitemap
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

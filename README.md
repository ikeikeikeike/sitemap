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

##### Basic

```elixir
defmodule Sitemaps do
  use Sitemap

  create do
    add "path1", priority: 0.5, changefreq: "hourly", expires: nil, mobile: true
  end

  ping
end
```

##### As a function

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

##### With Ecto

```elixir
defmodule Sitemaps do
  use Sitemap,
    host: "http://#{Application.get_env(:myapp, MyApp.Endpoint)[:url][:host]}",
    files_path: "static/",
    public_path: ""

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

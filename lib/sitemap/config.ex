defmodule Sitemap.Config do
  defstruct [
    :max_sitemap_files,     # Max sitemap links per index file
    :max_sitemap_links,     # Max links per sitemap
    :max_sitemap_news,      # Max news sitemap per index_file
    :max_sitemap_images,    # Max images per url
    :max_sitemap_filesize,  # Bytes
    :host,                  # Your domain, also host with http scheme.
    :filename,              # Name of sitemap file.
    :public_path,           # After domain path's location on URL.
    :files_path,            # Generating sitemps to this directory path.
    :adapter,
    :verbose,
    :compress,
    :create_index,
  ]

  def start_link, do: configure nil
  def configure,  do: configure nil
  def configure(overwrite) do
    ow = overwrite
    start_link(%__MODULE__{
      max_sitemap_files:    ow[:max_sitemap_files]    || System.get_env("SITEMAP_MAXFILES")      || Application.get_env(:sitemap, :max_sitemap_files,    10_000),
      max_sitemap_links:    ow[:max_sitemap_links]    || System.get_env("SITEMAP_MAX_LINKS")     || Application.get_env(:sitemap, :max_sitemap_links,    10_000),
      max_sitemap_news:     ow[:max_sitemap_news]     || System.get_env("SITEMAP_MAXNEWS")       || Application.get_env(:sitemap, :max_sitemap_news,     1_000),
      max_sitemap_images:   ow[:max_sitemap_images]   || System.get_env("SITEMAP_MAXIMAGES")     || Application.get_env(:sitemap, :max_sitemap_images,   1_000),
      max_sitemap_filesize: ow[:max_sitemap_filesize] || System.get_env("SITEMAP_MAXFILESIZE")   || Application.get_env(:sitemap, :max_sitemap_filesize, 5_000_000),
      host:                 ow[:host]                 || System.get_env("SITEMAP_HOST")          || Application.get_env(:sitemap, :host,   "http://www.example.com"),
      filename:             ow[:filename]             || System.get_env("SITEMAP_FILENAME")      || Application.get_env(:sitemap, :filename,             "sitemap"),
      files_path:           ow[:files_path]           || System.get_env("SITEMAP_SITEMAPS_PATH") || Application.get_env(:sitemap, :files_path,           "sitemaps/"),
      public_path:          ow[:public_path]          || System.get_env("SITEMAP_PUBLIC_PATH")   || Application.get_env(:sitemap, :public_path,          "sitemaps/"),
      adapter:              ow[:adapter]              || System.get_env("SITEMAP_ADAPTER")       || Application.get_env(:sitemap, :adapter, Sitemap.Adapters.File),
      verbose:              ow[:verbose]              || System.get_env("SITEMAP_VERBOSE")       || Application.get_env(:sitemap, :verbose,              true),
      compress:             ow[:compress]             || System.get_env("SITEMAP_COMPRESS")      || Application.get_env(:sitemap, :compress,            true),
      create_index:         ow[:create_index]         || System.get_env("SITEMAP_CREATE_INDEX")  || Application.get_env(:sitemap, :create_index,         :auto),
    })
  end

  def get do
    Agent.get(__MODULE__, fn config -> config end)
  end

  def set(key, value) do
    Agent.update(__MODULE__, fn config ->
      Map.update!(config, key, fn _ -> value end)
    end)
  end

  def update(overwrite) do
    Enum.each overwrite, fn {key, value} ->
      set(key, value)
    end
  end

  defp start_link(value) do
    Agent.start_link(fn -> value end, name: __MODULE__)
  end
end

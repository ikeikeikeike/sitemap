defmodule ExSitemapGenerator.Config do
  defstruct [
    :max_sitemap_files,     # max sitemap links per index file
    :max_sitemap_links,     # max links per sitemap
    :max_sitemap_news,      # max news sitemap per index_file
    :max_sitemap_images,    # max images per url
    :max_sitemap_filesize,  # bytes
    :host,
    :filename,
    :public_path,
    :sitemaps_path,
    :adapter,
    :verbose,
    :compress,
    :create_index,
  ]

  def configure, do: configure nil
  def configure(overwrite) do
    ow = overwrite
    start_link(%__MODULE__{
      max_sitemap_files:    ow[:max_sitemap_files]    || System.get_env("SITEMAP_MAXFILES")      || Application.get_env(:ex_sitemap_generator, :max_sitemap_files,    50_000),
      max_sitemap_links:    ow[:max_sitemap_links]    || System.get_env("SITEMAP_MAX_LINKS")     || Application.get_env(:ex_sitemap_generator, :max_sitemap_links,    50_000),
      max_sitemap_news:     ow[:max_sitemap_news]     || System.get_env("SITEMAP_MAXNEWS")       || Application.get_env(:ex_sitemap_generator, :max_sitemap_news,     1_000),
      max_sitemap_images:   ow[:max_sitemap_images]   || System.get_env("SITEMAP_MAXIMAGES")     || Application.get_env(:ex_sitemap_generator, :max_sitemap_images,   1_000),
      max_sitemap_filesize: ow[:max_sitemap_filesize] || System.get_env("SITEMAP_MAXFILESIZE")   || Application.get_env(:ex_sitemap_generator, :max_sitemap_filesize, 10_000_000),
      host:                 ow[:host]                 || System.get_env("SITEMAP_HOST")          || Application.get_env(:ex_sitemap_generator, :host,                 "http://www.example.com"),
      filename:             ow[:filename]             || System.get_env("SITEMAP_FILENAME")      || Application.get_env(:ex_sitemap_generator, :filename,             ""),
      public_path:          ow[:public_path]          || System.get_env("SITEMAP_PUBLIC_PATH")   || Application.get_env(:ex_sitemap_generator, :public_path,          ""),
      sitemaps_path:        ow[:sitemaps_path]        || System.get_env("SITEMAP_SITEMAPS_PATH") || Application.get_env(:ex_sitemap_generator, :sitemaps_path,        "sitemaps/"),
      adapter:              ow[:adapter]              || System.get_env("SITEMAP_ADAPTER")       || Application.get_env(:ex_sitemap_generator, :adapter,              ExSitemapGenerator.Adapters.File),
      verbose:              ow[:verbose]              || System.get_env("SITEMAP_VERBOSE")       || Application.get_env(:ex_sitemap_generator, :verbose,              true),
      compress:             ow[:compress]             || System.get_env("SITEMAP_COMPRESS")      || Application.get_env(:ex_sitemap_generator, :comparess,            true),
      create_index:         ow[:create_index]         || System.get_env("SITEMAP_CREATE_INDEX")  || Application.get_env(:ex_sitemap_generator, :create_index,         :auto),
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

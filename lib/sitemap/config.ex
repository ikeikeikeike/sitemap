defmodule Sitemap.Config do
  import Sitemap.Funcs, only: [getenv: 1, nil_or: 1]

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
      max_sitemap_files:    nil_or([ow[:max_sitemap_files]   , getenv("SITEMAP_MAXFILES")     , Application.get_env(:sitemap, :max_sitemap_files,    10_000)]),
      max_sitemap_links:    nil_or([ow[:max_sitemap_links]   , getenv("SITEMAP_MAXLINKS")     , Application.get_env(:sitemap, :max_sitemap_links,    10_000)]),
      max_sitemap_news:     nil_or([ow[:max_sitemap_news]    , getenv("SITEMAP_MAXNEWS")      , Application.get_env(:sitemap, :max_sitemap_news,     1_000)]),
      max_sitemap_images:   nil_or([ow[:max_sitemap_images]  , getenv("SITEMAP_MAXIMAGES")    , Application.get_env(:sitemap, :max_sitemap_images,   1_000)]),
      max_sitemap_filesize: nil_or([ow[:max_sitemap_filesize], getenv("SITEMAP_MAXFILESIZE")  , Application.get_env(:sitemap, :max_sitemap_filesize, 5_000_000)]),
      host:                 nil_or([ow[:host]                , getenv("SITEMAP_HOST")         , Application.get_env(:sitemap, :host,   "http://www.example.com")]),
      filename:             nil_or([ow[:filename]            , getenv("SITEMAP_FILENAME")     , Application.get_env(:sitemap, :filename,            "sitemap")]),
      files_path:           nil_or([ow[:files_path]          , getenv("SITEMAP_SITEMAPS_PATH"), Application.get_env(:sitemap, :files_path,          "sitemaps/")]),
      public_path:          nil_or([ow[:public_path]         , getenv("SITEMAP_PUBLIC_PATH")  , Application.get_env(:sitemap, :public_path,         "sitemaps/")]),
      adapter:              nil_or([ow[:adapter]             , getenv("SITEMAP_ADAPTER")      , Application.get_env(:sitemap, :adapter, Sitemap.Adapters.File)]),
      verbose:              nil_or([ow[:verbose]             , getenv("SITEMAP_VERBOSE")      , Application.get_env(:sitemap, :verbose,              true)]),
      compress:             nil_or([ow[:compress]            , getenv("SITEMAP_COMPRESS")     , Application.get_env(:sitemap, :compress,             true)]),
      create_index:         nil_or([ow[:create_index]        , getenv("SITEMAP_CREATE_INDEX") , Application.get_env(:sitemap, :create_index,        "auto")]),
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

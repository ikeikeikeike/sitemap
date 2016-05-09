defmodule Sitemap.Generator do
  alias Sitemap.Namer
  alias Sitemap.Builders.File, as: FileBuilder
  alias Sitemap.Builders.Indexfile
  alias Sitemap.Location

  def add(link, attrs \\ []) do
    case FileBuilder.add(link, attrs) do
      :ok   -> :ok
      :full ->
        full
        add(link, attrs)
    end
  end

  def full do
    Indexfile.add
    FileBuilder.finalize_state
  end

  def fin do
    full
    reset
  end

  def reset do
    Indexfile.write
    Indexfile.finalize_state
    Namer.update_state :file, :count, nil
  end

  # def group do end

  def ping(urls \\ []) do
    urls = ~w(http://google.com/ping?sitemap=
    http://www.google.com/webmasters/sitemaps/ping?sitemap=
    http://www.bing.com/webmaster/ping.aspx?sitemap=
    http://submissions.ask.com/ping?sitemap=) ++ urls

    indexurl = Location.url :indexfile

    :application.start(:inets)
    Enum.each urls, fn url ->
      spawn(fn ->
        :httpc.request('#{url}#{indexurl}')
        IO.puts "Successful ping of #{url}#{indexurl}"
      end)
    end
  end

end

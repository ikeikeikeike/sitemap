defmodule Sitemap.Generator do
  alias Sitemap.Namer
  alias Sitemap.Builders.File, as: FileBuilder
  alias Sitemap.Builders.Indexfile

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
    Indexfile.write
    Indexfile.finalize_state
    Namer.update_state :file, :count, nil
  end

  # def group do end

  def ping_search_engines do
  end

  def set_options(options \\ []) do
  end

end

defmodule ExSitemapGenerator.Generator do
  alias ExSitemapGenerator.Builders.File, as: FileBuilder
  alias ExSitemapGenerator.Builders.Indexfile

  def add(link, attrs \\ []) do
    case FileBuilder.add(link, attrs) do
      :ok   -> :ok
      :full ->
        finalize
        add(link, attrs)
      :fin ->
        # FileBuilder.finalize
        add(link, attrs)
    end
  end

  def finalize do
    add_to_index
    FileBuilder.finalize
  end

  def add_to_index do
    Indexfile.add
  end

  # def group do end

  def ping_search_engines do
  end

  def set_options(options \\ []) do
  end

end

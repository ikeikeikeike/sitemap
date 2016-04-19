defmodule ExSitemapGenerator.Generator do
  alias ExSitemapGenerator.Builders.File, as: FileBuilder
  alias ExSitemapGenerator.Builders.Indexfile

  alias ExSitemapGenerator.FullError
  alias ExSitemapGenerator.FinalizedError

  def add(link, attrs \\ []) do
    FileBuilder.add(link, attrs)
  rescue
    FullError ->
      add_to_index(attrs)
      add(link, attrs)
    FinalizedError ->
      FileBuilder.finalize
      add(link, attrs)
  end

  def add_to_index(options \\ []) do
    Indexfile.add(options)
  end

  # def group do end

  def ping_search_engines do
  end

  def set_options(options \\ []) do
    # Enum.each ~w(filename namer), fn(key) ->
      # if value = opts.delete(key.to_sym) do
        # send("#{key}=", value)
      # end
    # end

    Enum.each options, fn{k, v} ->
      IO.inspect("#{k}=#{v}")
      # send("#{key}=", value)
    end
  end

end

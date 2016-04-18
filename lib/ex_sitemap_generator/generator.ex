defmodule ExSitemapGenerator.Generator do
  alias ExSitemapGenerator.Builders.File
  alias ExSitemapGenerator.Builders.Indexfile
  alias ExSitemapGenerator.FullError
  alias ExSitemapGenerator.FinalizedError

  def add(link, options \\ []) do
    File.add(link, options)
  rescue
    FullError ->
      add_to_index(File)
      add(link, options)
    FinalizedError ->
      File.finalize
      add(link, options)
  end

  def add_to_index(file, options \\ []) do
    Indexfile.add(file, options)
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

defmodule ExSitemapGenerator.Generator do

  def add(link, options \\ []) do
    {link, options}
  end

  def add_to_index(link, options \\ []) do
    {link, options}
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

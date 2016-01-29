defmodule ExSitemapGenerator.Generator do

  defmacro create(options \\ [], contents) do
    contents =
      case contents do
        [do: block] ->
          quote do
            unquote(block)
            :ok
          end
        _ ->
          quote do
            try(unquote(contents))
            :ok
          end
      end

    contents = Macro.escape(contents, unquote: true)

    quote bind_quoted: binding do
      Code.eval_quoted(contents)
    end
  end

  def add(link, options \\ []) do
    {link, options}
  end

  def add_to_index(link, options \\ []) do
    {link, options}
  end

  # def group do end

  def ping_search_engines do
  end

  # Set each option on this instance using accessor methods.  This will affect
  # both the sitemap and the sitemap index.
  #
  # If both `filename` and `namer` are passed, set filename first so it
  # doesn't override the latter.
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

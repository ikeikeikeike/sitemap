defmodule ExSitemapGenerator.LinkSet do

  @type t :: ExSitemapGenerator.t
  @type element :: any

  @spec create(t, (element -> any)) :: :ok
  def create(opts, fun) when is_list(opts) and is_function(fun)  do
    set_options(opts)
    fun.(opts)
    :ok
  end

  def create(fun) when is_function(fun) do
    fun.([])
    :ok
  end

  # Set each option on this instance using accessor methods.  This will affect
  # both the sitemap and the sitemap index.
  #
  # If both `filename` and `namer` are passed, set filename first so it
  # doesn't override the latter.
  def set_options(opts \\ []) do
    # Enum.each ~w(filename namer), fn(key) ->
      # if value = opts.delete(key.to_sym) do
        # send("#{key}=", value)
      # end
    # end

    Enum.each opts, fn{k, v} ->
      IO.inspect("#{k}=#{v}")
      # send("#{key}=", value)
    end
  end

end

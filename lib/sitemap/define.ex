defmodule Sitemap.Define do
  defmacro define(key, value) do
    quote do
      @unquote(key)(unquote(value))
      def unquote(key)(), do: @unquote(key)()
    end
  end
end

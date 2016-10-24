defmodule Sitemap.DSL do
  defmacro __using__(opts) do
    quote do
      @__use_resource__ unquote(opts)

      import unquote(__MODULE__)
      import Sitemap.Generator
    end
  end

  defmacro create(options, contents) do
    quote do
      Sitemap.Config.update @__use_resource__
      Sitemap.Config.update unquote(options)
      create unquote(contents ++ [use: false])
    end
  end

  defmacro create(contents) do
    case contents do
      [do: block] ->
        quote do
          Sitemap.Config.update @__use_resource__
          unquote(block); fin()
        end
      [do: block, use: false] ->
        quote do
          unquote(block); fin()
        end
    end
  end
end

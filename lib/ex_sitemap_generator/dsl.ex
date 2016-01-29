defmodule ExSitemapGenerator.DSL do
  defmacro __using__(_opts) do
    quote do
      import ExSitemapGenerator.DSL

      Module.register_attribute(__MODULE__, :alts, accumulate: :true)

      @before_compile ExSitemapGenerator.DSL
    end
  end

  defmacro alt(name, options \\ []) do
    quote do
      @alts {unquote(name), unquote(options)}
    end
  end

  defmacro __before_compile__(env) do
    alts = Module.get_attribute(env.module, :alts)
    quote do
      def alts, do: unquote(alts)
    end
  end
end

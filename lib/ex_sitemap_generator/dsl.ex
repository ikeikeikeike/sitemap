defmodule ExSitemapGenerator.DSL do
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :opts, accumulate: true)
      @before_compile unquote(__MODULE__)

      import unquote(__MODULE__)
      import ExSitemapGenerator.Generator
    end
  end

  defmacro create(contents) do
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

    Code.eval_quoted(quote do
      unquote(contents)
    end)
  end

  defmacro alt(name, options) do
    quote do
      @opt {unquote(name), unquote(options)}
    end
  end

  defmacro __before_compile__(env) do
    opts = Module.get_attribute(env.module, :opts)
    quote do
      defp __resource__, do: unquote(opts)
    end
  end
end

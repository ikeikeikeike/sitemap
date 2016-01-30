defmodule ExSitemapGenerator do

  @doc false
  defmacro __using__(_opts) do
    quote do
      use ExSitemapGenerator.DSL
    end
  end

end

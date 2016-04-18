defmodule ExSitemapGenerator.Exceptions do
  defmacro __using__(_) do
    quote do
      defmodule FullError do
        defexception message: nil
      end

      defmodule FinalizedError do
        defexception message: nil
      end
    end
  end
end

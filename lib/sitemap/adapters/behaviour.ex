defmodule Sitemap.Adapters.Behaviour do
  @callback write(name :: String.t(), data :: String.t()) :: :ok | {:error, term}
end

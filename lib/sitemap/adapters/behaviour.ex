defmodule Sitemap.Adapters.Behaviour do
  use Behaviour

  @callback write(name::String.t, data::String.t) :: :ok | {:error, term}
end

defmodule Sitemap.XpathNamespace do
  import SweetXml

  def xpath_namespace(parsed, spec) do
    parsed
    |> xpath(spec)
    |> xpath(~x"//namespace::*[name()='']")
    |> case do
      {_, _, _, _, namespace} -> to_string(namespace)
      _ -> nil
    end
  end
end

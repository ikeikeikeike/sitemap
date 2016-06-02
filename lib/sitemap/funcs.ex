defmodule Sitemap.Funcs do
  def iso8601 do
    {{yy, mm, dd}, {hh, mi, ss}} = :calendar.universal_time
    iso8601(yy, mm, dd, hh, mi, ss)
  end
  def iso8601(yy, mm, dd, hh, mi, ss) do
    "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ"
    |> :io_lib.format([yy, mm, dd, hh, mi, ss])
    |> IO.iodata_to_binary
  end

  def eraser(elements) do
    Enum.filter elements, fn elm ->
      case elm do
        e when is_list(e) -> eraser(e)
        nil -> false
        _   -> !!elem(elm, 2)
      end
    end
  end

  def yes_no(bool) do
    if bool == false, do: "no", else: "yes"
  end

  def allow_deny(bool) do
    if bool == false, do: "deny", else: "allow"
  end

  def autoplay(bool) do
    if bool, do: "ap=1", else: "ap=0"
  end

  def getenv(key) do
    x = System.get_env(key)
    cond do
      x == "false"  -> false
      x == "true"   -> true
      is_numeric(x) ->
        {num, _} = Integer.parse(x)
         num
      true          -> x
    end
  end

  def nil_or(opts), do: nil_or(opts, "")
  def nil_or([], value), do: value
  def nil_or([h|t], _value) do
    case h do
      v when is_nil(v) -> nil_or(t, "")
      v -> nil_or([], v)
    end
  end

  def is_numeric(str) when is_nil(str), do: false
  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      {_num, _r} -> false
      :error     -> false
    end
  end

end

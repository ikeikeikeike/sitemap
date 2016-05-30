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

  def autoplay(bool) do
    if bool, do: "ap=1", else: "ap=0"
  end

end

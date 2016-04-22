defmodule ExSitemapGenerator.Util do
  def iso8601 do
    {{yy, mm, dd}, {hh, mi, ss}} = :calendar.universal_time
    :io_lib.format("~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0B", [yy, mm, dd, hh, mi, ss])
    |> IO.iodata_to_binary
  end
end

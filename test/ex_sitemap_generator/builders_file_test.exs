Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.BuildersFileTest do

  use ExUnit.Case
  alias ExSitemapGenerator.Builders.File

  setup do
    ExSitemapGenerator.start_link
    IO.puts "doing"
    on_exit fn ->
      IO.puts "done"
    end
    # Returns extra metadata, it must be a dict
    # {:ok, hello: "world"}
  end

  test "init Builders.File" do
    IO.inspect File.get
    File.set :location, 12345
    IO.inspect File.get
  end

  test "finalize Builders.File" do
    IO.inspect File.get
    File.set :news_count, 45678
    IO.inspect File.get
  end

end

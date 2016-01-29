Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.DSLTest do

  use ExUnit.Case
  use ExSitemapGenerator

  alt :hello
  alt :ikeda
  alt :tatsuo, true
  alt :unko, ab: false

  test "alts option" do
    assert alts == [unko: [ab: false], tatsuo: true, ikeda: [], hello: []]
  end

  create do
    IO.inspect [1234]
    IO.inspect 2131231
    false
  end

end

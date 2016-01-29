Code.require_file "../../test_helper.exs", __ENV__.file

defmodule ExSitemapGenerator.GeneratorTest do

  use ExUnit.Case
  use ExSitemapGenerator

  test "create macro" do
    resp = create do
      false
    end

    assert resp == {:ok, []}
  end

  test "add function" do
    assert add("link", []) == {"link", []}
  end

  # test "add_to_index function" do
    # assert add("link", []) == {"link", []}
  # end

end

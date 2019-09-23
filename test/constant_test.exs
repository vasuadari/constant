defmodule ConstantTest do
  use ExUnit.Case, async: true

  defmodule TestConstant do
    import Constant

    defconst a: 1

    defconst [b: "c"], atomize_values: true

    defconst c: %{a: 2}

    defconst d: {0, 0}

    defconst e: [1, 2, 3]

    defconst f: [a: 1, b: 2]
  end

  test "returns integer for a constant" do
    assert TestConstant.a() == 1
  end

  test "returns atom value for a constant when atomize_values option is true" do
    assert TestConstant.b() == :c
  end

  test "returns map for a constant" do
    assert TestConstant.c() == %{a: 2}
  end

  test "returns tuple for a constant" do
    assert TestConstant.d() == {0, 0}
  end

  test "returns list for a constant" do
    assert TestConstant.e() == [1, 2, 3]
  end

  test "returns keyword list for a constant" do
    assert TestConstant.f() == [a: 1, b: 2]
  end

  test "raises exception when key is not an atom" do
    assert_raise RuntimeError, "Key has to be an atom", fn ->
      defmodule Dummy do
        import Constant

        defconst [{"g", 1}]
      end
    end
  end
end

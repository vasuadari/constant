defmodule ConstantTest do
  use ExUnit.Case, async: true

  defmodule IntegerTest do
    import Constant

    defconst(a: 1)
  end

  defmodule StringTest do
    import Constant

    defconst([b: "c"], atomize: true)
  end

  defmodule MapTest do
    import Constant

    defconst(c: %{a: 2})
  end

  defmodule TupleTest do
    import Constant

    defconst(d: {0, 0})
  end

  defmodule ListTest do
    import Constant

    defconst(e: [1, 2, 3])
  end

  defmodule KeywordTest do
    import Constant

    defconst(f: [a: 1, b: 2])
  end

  test "returns integer for a constant" do
    assert IntegerTest.a() == 1
  end

  test "returns atom & string constant when atomize_values option is true" do
    assert StringTest.b() == "c"

    assert StringTest.b_atom() == :c
  end

  test "returns map for a constant" do
    assert MapTest.c() == %{a: 2}
  end

  test "returns tuple for a constant" do
    assert TupleTest.d() == {0, 0}
  end

  test "returns list for a constant" do
    assert ListTest.e() == [1, 2, 3]
  end

  test "returns keyword list for a constant" do
    assert KeywordTest.f() == [a: 1, b: 2]
  end

  test "raises exception when key is not an atom" do
    assert_raise RuntimeError, "Key has to be an atom", fn ->
      defmodule Dummy do
        import Constant

        defconst([{"g", 1}])
      end
    end
  end

  test "raises exception when value cannot be nil" do
    assert_raise RuntimeError, "Value cannot be nil", fn ->
      defmodule NilTest do
        import Constant

        defconst(h: nil)
      end
    end
  end

  describe "{key}?/1" do
    test "returns true when a is 1" do
      assert IntegerTest.a?(1)
    end

    test "returns false when a is 2" do
      refute IntegerTest.a?(2)
    end

    test "returns true when b is string c" do
      assert StringTest.b?("c")
    end

    test "returns true when b is atom c" do
      assert StringTest.b?(:c)
    end
  end
end

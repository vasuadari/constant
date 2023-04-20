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

    require IntegerTest
    assert IntegerTest.const_a() = 1
  end

  test "returns atom & string constant when atomize_values option is true" do
    assert StringTest.b() == "c"
    assert StringTest.b_atom() == :c

    require StringTest
    assert StringTest.const_b() = "c"
    assert StringTest.const_b_atom() = :c
  end

  test "returns map for a constant" do
    assert MapTest.c() == %{a: 2}
    require MapTest
    assert MapTest.const_c() = %{a: 2}
  end

  test "returns tuple for a constant" do
    assert TupleTest.d() == {0, 0}
    require TupleTest
    assert TupleTest.const_d() = {0, 0}
  end

  test "returns list for a constant" do
    assert ListTest.e() == [1, 2, 3]
    require ListTest
    assert ListTest.const_e() = [1, 2, 3]
  end

  test "returns keyword list for a constant" do
    assert KeywordTest.f() == [a: 1, b: 2]
    require KeywordTest
    assert KeywordTest.const_f() = [a: 1, b: 2]
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

  describe "values/0" do
    test "returns list of values defined" do
      assert IntegerTest.values() == [1]
      assert StringTest.values() == ["c"]
      assert MapTest.values() == [%{a: 2}]
      assert TupleTest.values() == [{0, 0}]
      assert KeywordTest.values() == [[a: 1, b: 2]]
    end
  end

  describe "atom_values/0" do
    test "returns list of atom values" do
      assert IntegerTest.atom_values() == []
      assert StringTest.atom_values() == [:c]
      assert MapTest.atom_values() == []
      assert TupleTest.atom_values() == []
      assert KeywordTest.atom_values() == []
    end
  end

  describe "all_values/0" do
    test "returns list of atom and non-atom values defined" do
      assert IntegerTest.all_values() == [1]
      assert StringTest.all_values() == ["c", :c]
      assert MapTest.all_values() == [%{a: 2}]
      assert TupleTest.all_values() == [{0, 0}]
      assert KeywordTest.all_values() == [[a: 1, b: 2]]
    end
  end

  describe "valid?/1" do
    test "returns true when given value is valid" do
      assert IntegerTest.valid?(1)
      assert StringTest.valid?("c")
      assert StringTest.valid?(:c)
    end

    test "returns false when given value is invalid" do
      refute IntegerTest.valid?(2)
      refute StringTest.valid?("x")
      refute StringTest.valid?(:z)
    end
  end

  describe "dump/0" do
    test "returns true when given value is valid" do
      assert IntegerTest.dump() == [a: 1]
      assert StringTest.dump() == [b: "c"]
      assert MapTest.dump() == [c: %{a: 2}]
      assert TupleTest.dump() == [d: {0, 0}]
      assert KeywordTest.dump() == [f: [a: 1, b: 2]]
    end
  end

  describe "key_of/1" do
    test "returns key of given value" do
      assert :a = IntegerTest.key_of(1)
    end

    test "returns nil when given value is not present" do
      refute IntegerTest.key_of(2)
    end
  end

  describe "key_of/2" do
    test "returns key for any given constant module" do
      modules = [IntegerTest, StringTest, MapTest, KeywordTest, TupleTest, ListTest]

      assert :a = Constant.key_of(1, modules)
      assert :b = Constant.key_of("c", modules)
      assert :c = Constant.key_of(%{a: 2}, modules)
      assert :d = Constant.key_of({0, 0}, modules)
      assert :e = Constant.key_of([1, 2, 3], modules)
      assert :f = Constant.key_of([a: 1, b: 2], modules)
    end
  end
end

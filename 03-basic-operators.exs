# https://elixir-lang.org/getting-started/basic-operators.html

ExUnit.start()

defmodule BasicOperators do
  use ExUnit.Case

  test "Basic operators" do
    assert [1, 2, 3] ++ [4, 5, 6] == [1, 2, 3, 4, 5, 6]
    assert [1, 2, 3] -- [2] == [1, 3]

    assert "foo" <> "bar" == "foobar"
    assert true and true
    assert false or is_atom(:example)

    assert_raise BadBooleanError, fn -> 1 and true end

    # or and and are short-circuit operators.
    # They only execute the right side if the left side is not enough to determine the result:
    refute false and raise("This error will never be raised")
    assert true or raise("This error will never be raised")

    # Besides these boolean operators, Elixir also provides ||, && and ! which accept arguments of any type.
    # For these operators, all values except false and nil will evaluate to true:
    assert (1 || true) == 1
    assert (false || 11) == 11
    assert (nil && 13) == nil
    assert (true && 17) == 17

    refute !true
    refute !1
    assert !nil

    assert 1 == 1
    assert 1 != 2
    assert 1 < 2

    # The difference between == and === is that the latter is more strict when comparing integers and floats:
    assert 1 == 1.0
    refute 1 === 1.0
  end
end

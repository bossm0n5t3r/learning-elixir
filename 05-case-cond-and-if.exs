# https://elixir-lang.org/getting-started/case-cond-and-if.html

ExUnit.start()

defmodule CaseCondAndIf do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/case-cond-and-if.html#case
  test "case" do
    simple_case =
      case {1, 2, 3} do
        {4, 5, 6} -> "This clause won't match"
        {1, x, 3} -> "This clause will match and bind x to 2 in this clause"
        _ -> "This clause would match any value"
      end

    assert simple_case == "This clause will match and bind x to 2 in this clause"

    x = 1

    pin_operator =
      case 10 do
        ^x -> "Won't match"
        _ -> "Will match"
      end

    assert pin_operator == "Will match"

    extra_condition_clause =
      case {1, 2, 3} do
        {1, x, 3} when x > 0 -> "Will match"
        _ -> "Would match, if guard condition were not satisfied"
      end

    assert extra_condition_clause == "Will match"

    # If none of the clauses match, an error is raised:
    assert_raise CaseClauseError, fn ->
      none_of_the_clauses =
        case :ok do
          :error -> "Won't match"
        end
    end

    # Note anonymous functions can also have multiple clauses and guards:
    f = fn
      x, y when x > 0 -> x + y
      x, y -> x * y
    end

    assert f.(1, 3) == 4
    assert f.(-1, 3) == -3

    # The number of arguments in each anonymous function clause needs to be the same,
    # otherwise an error is raised.
  end

  # https://elixir-lang.org/getting-started/case-cond-and-if.html#cond
  test "cond" do
    cond_example_0 =
      cond do
        2 + 2 == 5 -> "This will not be true"
        2 * 2 == 3 -> "Nor this"
        1 + 1 == 2 -> "But this will"
      end

    assert cond_example_0 == "But this will"

    cond_example_1 =
      cond do
        2 + 2 == 5 -> "This will not be true"
        2 * 2 == 3 -> "Nor this"
        true -> "This is always true (equivalent to else)"
      end

    assert cond_example_1 == "This is always true (equivalent to else)"

    # Finally, note cond considers any value besides nil and false to be true:
    cond_example_2 =
      cond do
        hd([1, 2, 3]) -> "1 is considered as true"
      end

    assert cond_example_2 == "1 is considered as true"
  end

  # https://elixir-lang.org/getting-started/case-cond-and-if.html#if-and-unless
  test "if and unless" do
    if_example_0 =
      if true do
        "This works!"
      end

    assert if_example_0 == "This works!"

    unless_example_0 =
      unless true do
        "This will never be seen"
      end

    assert unless_example_0 == nil

    if_else_example_0 =
      if nil do
        "This won't be seen"
      else
        "This will"
      end

    assert if_else_example_0 == "This will"

    # If any variable is declared or changed inside if, case, and similar constructs,
    # the declaration and change will only be visible inside the construct.
    # For example:
    x = 1

    if_example_1 =
      if true do
        x = x + 1
      end

    assert if_example_1 == 2
    assert x == 1

    x =
      if true do
        x + 1
      else
        x
      end

    assert x == 2
  end
end

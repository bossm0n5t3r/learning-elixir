# https://elixir-lang.org/getting-started/pattern-matching.html

ExUnit.start()

defmodule PatternMatching do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/pattern-matching.html#the-match-operator
  test "The match operator" do
    x = 1
    assert_raise MatchError, fn -> 2 = x end
  end

  # https://elixir-lang.org/getting-started/pattern-matching.html#pattern-matching
  test "Pattern matching" do
    {a, b, c} = {:hello, "world", 42}
    assert a == :hello
    assert b == "world"

    assert_raise MatchError, fn ->
      {_, _, _} = {:hello, "world"}
    end

    assert_raise MatchError, fn ->
      {_, _, _} = [:hello, "world", 42]
    end

    {:ok, result} = {:ok, 13}
    assert result == 13

    assert_raise MatchError, fn ->
      {:ok, result} = {:error, :oops}
    end

    [a, b, c] = [1, 2, 3]
    assert a == 1

    [head | tail] = [1, 2, 3]
    assert head == 1
    assert tail == [2, 3]

    assert_raise MatchError, fn ->
      [head | tail] = []
    end

    list = [1, 2, 3]
    assert [0 | list] == [0, 1, 2, 3]
  end

  # https://elixir-lang.org/getting-started/pattern-matching.html#the-pin-operator
  test "The pin operator" do
    assert_raise MatchError, fn ->
      x = 1
      ^x = 2
    end

    assert_raise MatchError, fn ->
      1 = 2
    end

    x = 1
    [^x, 2, 3] = [1, 2, 3]
    {y, ^x} = {2, 1}
    assert y == 2

    assert_raise MatchError, fn ->
      {y, ^x} = {2, 2}
    end

    assert_raise MatchError, fn ->
      {y, 1} = {2, 2}
    end

    {x, x} = {1, 1}

    assert_raise MatchError, fn ->
      {x, x} = {1, 2}
    end

    [head | _] = [1, 2, 3]
    assert head == 1
  end
end

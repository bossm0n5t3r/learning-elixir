# https://elixir-lang.org/getting-started/recursion.html

ExUnit.start()

defmodule Recursion do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/recursion.html#loops-through-recursion
  test "Loops through recursion" do
    defmodule Recursion do
      def print_multiple_times(msg, n) when n > 0 do
        IO.puts(msg)
        print_multiple_times(msg, n - 1)
      end

      def print_multiple_times(_msg, 0) do
        :ok
      end
    end

    assert Recursion.print_multiple_times("Hello!", 3) == :ok

    assert_raise FunctionClauseError, fn ->
      Recursion.print_multiple_times("Hello!", -1)
    end
  end

  # https://elixir-lang.org/getting-started/recursion.html#reduce-and-map-algorithms
  test "Reduce and map algorithms" do
    defmodule Math do
      def sum_list([head | tail], accumulator) do
        sum_list(tail, head + accumulator)
      end

      def sum_list([], accumulator) do
        accumulator
      end

      def double_each([head | tail]) do
        [head * 2 | double_each(tail)]
      end

      def double_each([]) do
        []
      end
    end

    assert Math.sum_list([1, 2, 3], 0) == 6
    assert Math.double_each([1, 2, 3]) == [2, 4, 6]

    assert Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end) == 6
    assert Enum.reduce([1, 2, 3], 0, &+/2) == 6
    assert Enum.map([1, 2, 3], fn x -> x * 2 end) == [2, 4, 6]
    assert Enum.map([1, 2, 3], &(&1 * 2)) == [2, 4, 6]
  end
end

# https://elixir-lang.org/getting-started/enumerables-and-streams.html

ExUnit.start()

defmodule EnumerablesAndStreams do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/enumerables-and-streams.html#enumerables
  test "Enumerables" do
    assert Enum.map([1, 2, 3], fn x -> x * 2 end) == [2, 4, 6]
    assert Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end) == [2, 12]
    assert Enum.map(1..3, fn x -> x * 2 end) == [2, 4, 6]
    assert Enum.reduce(1..3, 0, &+/2) == 6
  end

  # https://elixir-lang.org/getting-started/enumerables-and-streams.html#eager-vs-lazy
  test "Eager vs Lazy" do
    odd? = &(rem(&1, 2) != 0)

    assert Enum.filter(1..3, odd?) == [1, 3]
    assert 1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum() == 7_500_000_000
  end

  # https://elixir-lang.org/getting-started/enumerables-and-streams.html#the-pipe-operator
  test "The pipe operator" do
    odd? = &(rem(&1, 2) != 0)
    assert Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?)) == 7_500_000_000
    assert 1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum() == 7_500_000_000
  end

  # https://elixir-lang.org/getting-started/enumerables-and-streams.html#streams
  test "Streams" do
    odd? = &(rem(&1, 2) != 0)

    assert 1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum() == 7_500_000_000

    stream_cycle = Stream.cycle([1, 2, 3])
    assert Enum.take(stream_cycle, 10) == [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]

    stream_unfold = Stream.unfold("hełło", &String.next_codepoint/1)
    assert Enum.take(stream_unfold, 3) == ["h", "e", "ł"]
  end
end

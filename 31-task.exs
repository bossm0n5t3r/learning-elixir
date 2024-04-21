# https://hexdocs.pm/elixir/Task.html

ExUnit.start()

defmodule TaskTest do
  use ExUnit.Case

  test "async_stream" do
    stream =
      ["long string", "longer string", "there are many of these"]
      |> Task.async_stream(fn text -> text |> String.codepoints() |> Enum.count() end)

    assert Enum.reduce(stream, 0, fn {:ok, num}, acc -> num + acc end) == 47
  end

  test "unbound async + take" do
    result =
      1..100
      |> Stream.take(10)
      |> Task.async_stream(fn i ->
        Process.sleep(100)
        i
      end)
      |> Enum.map(fn {:ok, val} -> val end)
      |> Enum.to_list()

    assert result == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  end

  test "async / await" do
    task = Task.async(fn -> Enum.sum(0..999_999) end)
    assert Task.await(task) == 499_999_500_000
  end

  test "await_many" do
    tasks = [
      Task.async(fn -> 1 + 1 end),
      Task.async(fn -> 2 + 3 end)
    ]

    assert Task.await_many(tasks) == [2, 5]
  end
end

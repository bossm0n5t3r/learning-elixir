# https://hexdocs.pm/elixir/IO.html
# https://hexdocs.pm/elixir/File.html

defmodule NumberPrinter do
  # docstring are quite useful you can generate docs out of them
  # check: https://hexdocs.pm/elixir/1.16/module-attributes.html
  # for more info
  @doc """
  Gets name from standard IO
  """
  def get_name do
    IO.gets("What is your name? ")
    |> String.trim()
  end

  def get_number do
    IO.getn("What is your favorite number? [0-9] ", 1)
    |> String.replace(~r/[^0-9]/, "")
  end

  def print_number do
    name = get_name()

    input_number = get_number()

    if String.trim(input_number) |> String.length() |> Kernel.==(0) do
      IO.puts("You should have entered 0 ~ 9.")
    else
      number = String.to_integer(input_number)
      IO.puts("Great! Here's a number for you #{name}:")
      IO.puts(get_ascii_number(number))
    end
  end

  def get_ascii_number(x) do
    path = Path.expand("resources/ascii-numbers.txt", __DIR__)

    case File.read(path) do
      {:ok, numbers} ->
        String.split(numbers, "\n") |> Enum.slice(x * 6, 6) |> Enum.join("\n")

      {:error, _} ->
        IO.puts("Error: ascii-numbers.txt file not found")
        System.halt(1)
    end
  end
end

ExUnit.start()

defmodule InputOutputTest do
  use ExUnit.Case
  import String

  test "checks if get_ascii_number returns string from resources/ascii-numbers.txt" do
    # this call checks if cow_art function returns art from txt file
    ascii_number = NumberPrinter.get_ascii_number(0)
    # first is implemented in String module
    assert trim(ascii_number) |> first == "0"
  end
end

NumberPrinter.print_number()

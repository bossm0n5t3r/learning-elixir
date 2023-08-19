# https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html

ExUnit.start()

defmodule BinariesStringsAndCharLists do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#unicode-and-code-points
  test "Unicode and Code Points" do
    # In Elixir you can use a ? in front of a character literal to reveal its code point:
    assert ?a == 97
    assert ?A == 65
    assert ?ł == 322

    assert "\u0061" == "a"
    assert (0x0061 = 97 = ?a) == 97
  end

  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#utf-8-and-encodings
  test "UTF-8 and Encodings" do
    string = "héllo"
    assert String.length(string) == 5
    assert byte_size(string) == 6

    assert String.codepoints("👩‍🚒") == ["👩", "‍", "🚒"]
    assert String.graphemes("👩‍🚒") == ["👩‍🚒"]
    assert String.length("👩‍🚒") == 1

    assert "hełło" <> <<0>> == <<104, 101, 197, 130, 197, 130, 111, 0>>
    assert IO.inspect("hełło", binaries: :as_binaries) == <<104, 101, 197, 130, 197, 130, 111>>
  end

  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#bitstrings
  test "Bitstrings" do
    # A bitstring is a fundamental data type in Elixir, denoted with the <<>> syntax.
    # A bitstring is a contiguous sequence of bits in memory.

    assert <<42>> == <<42::8>>
    assert <<3::4>> == <<3::size(4)>>
    assert <<0::1, 0::1, 1::1, 1::1>> == <<3::4>>

    # Any value that exceeds what can be stored by the number of bits provisioned is truncated:
    # Here, 257 in base 2 would be represented as 100000001,
    # but since we have reserved only 8 bits for its representation (by default),
    # the left-most bit is ignored and the value becomes truncated to 00000001,
    # or simply 1 in decimal.
    assert <<1>> == <<257>>
  end

  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#binaries
  test "Binaries" do
    # A binary is a bitstring where the number of bits is divisible by 8.
    assert is_bitstring(<<3::4>>)
    refute is_binary(<<3::4>>)
    assert is_bitstring(<<0, 255, 42>>)
    assert is_binary(<<0, 255, 42>>)
    assert is_binary(<<42::16>>)

    # We can pattern match on binaries / bitstrings:
    <<0, 1, x>> = <<0, 1, 2>>
    assert x == 2

    assert_raise MatchError, fn ->
      <<0, 1, x>> = <<0, 1, 2, 3>>
    end

    <<0, 1, x::binary>> = <<0, 1, 2, 3>>
    assert x == <<2, 3>>

    <<head::binary-size(2), rest::binary>> = <<0, 1, 2, 3>>
    assert head == <<0, 1>>
    assert rest == <<2, 3>>

    # A string is a UTF-8 encoded binary
    assert is_binary("hello")
    assert is_binary(<<239, 191, 19>>)
    refute String.valid?(<<239, 191, 19>>)

    assert "a" <> "ha" == "aha"
    assert <<0, 1>> <> <<2, 3>> == <<0, 1, 2, 3>>

    <<head, rest::binary>> = "banana"
    assert head == ?b
    assert rest == "anana"

    assert "ü" <> <<0>> == <<195, 188, 0>>
    <<x, rest::binary>> = "über"
    refute x == ?ü
    assert rest == <<188, 98, 101, 114>>

    <<x::utf8, rest::binary>> = "über"
    assert x == ?ü
    assert rest == "ber"
  end

  # https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#charlists
  test "Charlists" do
    # A charlist is a list of integers where all the integers are valid code points.
    assert [?h, ?e, ?l, ?l, ?o] == ~c"hello"

    # The key takeaway is that "hello" is not the same as 'hello'.
    # Generally speaking, double-quotes must always be used to represent strings in Elixir.
    assert ~c"hello" == ~c"hello"

    assert ~c"hełło" == [104, 101, 322, 322, 111]
    assert is_list(~c"hełło")

    assert to_charlist("hełło") == [104, 101, 322, 322, 111]
    assert to_string(~c"hełło") == "hełło"
    assert to_string(:hello) == "hello"
    assert to_string(1) == "1"
  end
end

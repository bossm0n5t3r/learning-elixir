# https://en.wikipedia.org/wiki/Quine_(computing)

d= ~S(IO.puts "d= ~S(#{d}\)"
IO.puts d)
IO.puts "d= ~S(#{d}\)"
IO.puts d

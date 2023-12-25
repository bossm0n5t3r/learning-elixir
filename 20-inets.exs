# just playing with inets - nothing special

require Record

defmodule WebServer do
  def run do
    :inets.start()

    options = [
      server_name: ~c"foo",
      server_root: ~c"/tmp",
      document_root: ~c"/tmp",
      port: 3000,
      modules: [App]
    ]

    {:ok, _pid} = :inets.start(:httpd, options)
    IO.puts("running on port 3000")
    # TODO better way to wait?
    receive do: (_ -> :ok)
  end
end

defmodule App do
  Record.defrecord(:mod, Record.extract(:mod, from_lib: "inets/include/httpd.hrl"))

  def unquote(:do)(data) do
    response =
      case mod(data, :request_uri) do
        ~c"/" -> ~c"hello world"
        _ -> [~c"hello ", mod(data, :request_uri)]
      end

    {:proceed, [response: {200, response}]}
  end
end

WebServer.run()

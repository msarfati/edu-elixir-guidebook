defmodule Exercises do
  def sum(list) do
    list |> List.foldl(0, fn x, acc -> x + acc end)
  end
  def another_sum(list) do
    list |> Enum.sum
  end
  def transform() do
    [1,[[2],3]]
    |> List.flatten
    |> Enum.reverse
    |> Enum.map(fn x -> x * x end)
  end
  def translate(string) do
      # Erlang:  crypto:hash(md5, "Testing").
      :crypto.hash(:md5, string)
      |> Base.encode16(case: :lower)
  end
  def parse_packet() do
    "c8e0eb160dd3b0c745cd3dfc0800450001725703400040115ea5c0a80101c0a801810035cbb4015e37b702a0818000010004000800000f6769746875622d72656c65617365731167697468756275736572636f6e74656e7403636f6d0000010001c00c0001000100000a170004b9c76f9ac00c0001000100000a170004b9c76e9ac00c0001000100000a170004b9c76c9ac00c0001000100000a170004b9c76d9ac01c0002000100000a17001404646e733103703031056e736f6e65036e657400c01c0002000100000a17000704646e7332c088c01c0002000100000a17000704646e7333c088c01c0002000100000a17000704646e7334c088c01c0002000100000a170017076e732d3134313109617773646e732d3438036f726700c01c0002000100000a170013066e732d31383109617773646e732d3232c02ec01c0002000100000a170019076e732d3138363709617773646e732d343102636f02756b00c01c0002000100000a170013066e732d35393609617773646e732d3130c092"
    |> Base.decode16
  end
end

defmodule IPv4Packet do
  def parse() do
    filename = "ipv4_packet.bin"
    case File.read(filename) do

      {:ok, packet} ->
        packet_byte_size = byte_size(packet)
#        packet_byte_size = byte_size(packet) - 342

#        << _ :: binary-size(packet_byte_size), dns_response :: binary >> = packet
        << binary-size(packet_byte_size), dns_response :: binary >> = packet

        <<
          _begin           :: binary-size(53),
          queries_name     :: binary-size(38),
          _rest            :: binary >>          = dns_response

        IO.puts "DNS query name = #{Enum.join(for <<c::utf8 <- queries_name>>, do: <<c::utf8>>)}"
#        IO.puts "DNS query name = #{queries_name |> Enum.map(fn(b) -> <<b::utf8>> end)}"
      _ ->
        IO.puts "Couldn't open #{filename}"
    end
  end
end
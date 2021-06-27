defmodule ID3Parser do
  def parse(filename) do
    case File.read(filename) do

      {:ok, mp3} ->
        mp3_byte_size = byte_size(mp3) - 128

        << _ :: binary-size(mp3_byte_size), id3_tag :: binary >> = mp3

        << "TAG", title   :: binary-size(30),
                  artist  :: binary-size(30),
                  album   :: binary-size(30),
                  year    :: binary-size(4),
                  _rest   :: binary >>          = id3_tag

        IO.puts "#{artist} - #{title} (#{album}, #{year})"
    _ ->
      IO.puts "Couldn't open #{filename}"
    end
  end
end
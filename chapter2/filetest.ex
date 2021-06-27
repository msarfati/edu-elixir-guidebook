defmodule MyFileReader do
  def get(filename) do
    case File.read(filename) do
      {:ok, _binary} ->
        IO.puts "File found"
      {:error, reason} ->
        IO.puts "Nope, I can't find that because #{reason}}"
    end
  end
end
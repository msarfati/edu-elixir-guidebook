# MyPipeFilter.my_filter("/Users/geist/Language/Michel Thomas Italian Course - Foundation, Advanced and Builder")
defmodule MyPipeFilter do
  def my_filter(dirpath) do
    dirpath
    |> Path.join("**/*.mp3")
    |> Path.wildcard
    |> Enum.filter(fn fname ->
      String.contains?(Path.basename(fname), "Lesson")
    end)
  end
end
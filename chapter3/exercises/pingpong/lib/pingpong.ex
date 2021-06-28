defmodule PingPong do
  @moduledoc """
  Main PingPong module, wherein I include this module-level doc string!

  # Header
  ## Another header
  Yes.
  """

  @doc """
  Greets the user.
  """
  def hello(name \\ "Josè", age \\ 55) do
    "Hello #{name}!\nYou age #{age} years old." |> IO.puts
  end
end

defmodule PingPong.Worker do
  @moduledoc """
  1. Spawn the `pong` worker:
  ```
  pid = spawn(PingPong.Worker, :pong, [])
  ```

  and check that it's alive:
  ```
  Process.alive?(pid)
  true
  ```

  2. Spawn the ping worker
  ```
  pid2 = spawn(PingPong.Worker, :ping, [pid])
  ```

  3. Both workers have been
  """
  def pong do
    receive do
      {:ping, sender_pid} ->
        IO.puts("Got :ping from #{inspect sender_pid}!")
        send(sender_pid, {:pong, self()})
      _ ->
        IO.puts("Unknown message.")
    end
  end

  def ping(recipient_pid) do
    send recipient_pid, {:ping, self()}
    IO.puts("Sent :ping to #{inspect recipient_pid}")

    receive do
      {:pong, sender_pid} ->
        IO.puts("Got :pong from #{inspect sender_pid}!")
      _ ->
        IO.puts("Unknown message.")
    end
  end
end

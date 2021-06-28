defmodule Metex.Worker do
  @moduledoc """
  Call with:
  {:ok, pid} = Metex.Worker.start_link
  Metex.Worker.get_temperature(pid, "Rio")

  Atoms like :stop and :reply which are manipulated by the callbacks are already defined in
  https://hexdocs.pm/elixir/1.12/GenServer.html#c:handle_call/3

  """

  use GenServer

  @name MW

  ## Client API

  @doc """
  Sending the name along with the options turns this GenServer into a singleton,ie
  only one instances of this server can be created. By default, an infinite
  number of GenServers of this type can be created.

  Observation: this also allows it to act as a kind of class "self" like in Python
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  def get_temperature(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_stats(pid) do
    GenServer.call(pid, :get_stats)
  end

  def get_stats do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats(pid) do
    GenServer.cast(pid, :reset_stats)
  end

  def reset_stats do
    GenServer.cast(@name, :reset_stats)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  def terminate(reason, stats) do
    IO.puts "server terminated because of '#{inspect reason}'"
      inspect stats
    :ok
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp} C", new_stats}

      _ ->
        {:reply, :error, stats}
    end
  end

  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def handle_info(msg, stats) do
    IO.puts("received #{inspect msg}")
    {:noreply, stats}
  end

  ## Helper functions

  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  @apikey "dde0ced4c14d504a732f0c3dfbdd57ec"

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{@apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 + 1))
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end
end
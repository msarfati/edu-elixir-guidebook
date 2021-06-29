defmodule CacheX do
  @moduledoc """
  Documentation for `CacheX`.

  CacheX.write :asdf, 47
  CacheX.read :asdf
  CacheX.delete :asdf
  CacheX.exist? :asdf
  """
  use GenServer

  def write(key, value), do: GenServer.start_link(__MODULE__, {:ok, value}, [name: key])
  def read(key), do: GenServer.call(key, :value)
  def delete(key), do: GenServer.cast(key, :delete)
  def exist?(key) do
    pid = Process.whereis(key)
    if pid != nil, do: Process.alive?(pid), else: false
  end
#  def clear, do: GenServer.call(:)

  ## Callbacks

  def init({:ok, value}), do: {:ok, value}
  def handle_call(:value, _from, value), do: {:reply, value, value}
  def handle_cast(:delete, value), do: {:stop, :normal, value}

end

defmodule HelloEts.MemoryStore do
  # https://erlang.org/doc/man/ets.html

  @ets_config [
    {:read_concurrency, true},
    {:write_concurrency, true},
    :public,
    :set,
    :named_table
  ]

  def create_table() do
    :ets.new(__MODULE__, @ets_config)
  end

  def get(key) do
    case :ets.lookup(__MODULE__, key) do
      [] -> nil
      [{_key, value} | _rest] -> value
    end
  end

  def put(key, value) do
    :ets.insert(__MODULE__, [{key, value}])
    |> ok_or_error_response
  end

  def delete(key) do
    :ets.delete(__MODULE__, key)
    |> ok_or_error_response
  end

  def delete_table do
    :ets.delete(__MODULE__)
    |> ok_or_error_response
  end

  defp ok_or_error_response(ets_result) do
    if ets_result, do: :ok, else: :error
  end
end

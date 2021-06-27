defmodule HelloEts.FileStore do
  # https://erlang.org/doc/man/dets.htm

  def open(opts \\ []) do
    data_dir = opts[:data_dir] || "tmp"
    filename = "file_store_#{Mix.env()}"
    file = :binary.bin_to_list(Path.join(data_dir, filename))

    :dets.open_file(__MODULE__, file: file, type: :set)
  end

  def get(key) do
    case :dets.lookup(__MODULE__, key) do
      [] -> nil
      [{_key, value} | _rest] -> value
    end
  end

  def put(key, value) do
    :dets.insert(__MODULE__, [{key, value}])
  end

  def delete(key) do
    :dets.delete(__MODULE__, key)
  end

  def close do
    :dets.close(__MODULE__)
  end
end

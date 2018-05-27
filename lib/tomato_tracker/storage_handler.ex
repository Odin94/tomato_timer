defmodule StorageHandler do
  def put_task(name) do
    case get_tasks() do
      nil ->
        PersistentStorage.put(:data, :tasks, [name])

      tasks ->
        PersistentStorage.put(:data, :tasks, [name | get_tasks])
    end

    IO.inspect(get_tasks)
  end

  def get_tasks(name \\ nil) do
    case name do
      nil ->
        PersistentStorage.get(:data, :tasks)

      _ ->
        PersistentStorage.get(:data, :tasks)
        # |> Enum.filter(filter_fun)
    end
  end
end

# TODO: maybe add projects to group tasks
defmodule StorageHandler do
  def put_task(name) do
    case get_tasks() do
      nil ->
        PersistentStorage.put(:data, :tasks, [name])

      tasks ->
        new_tasks =
          [name | tasks]
          |> Enum.uniq()

        PersistentStorage.put(:data, :tasks, new_tasks)
    end

    IO.inspect(get_tasks)
  end

  def get_tasks(name \\ nil) do
    case name do
      nil ->
        PersistentStorage.get(:data, :tasks)

      name ->
        PersistentStorage.get(:data, :tasks)
        |> Enum.find(fn task_name -> name == task_name end)
    end
  end

  def put_tomato(task, timestamp \\ DateTime.utc_now()) do
    if get_tasks(task) == nil do
      put_task(task)
    end

    PersistentStorage.put(:data, :tomatoes, %{timestamp: timestamp, task: task})
  end
end

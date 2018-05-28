# TODO: maybe add projects to group tasks

# Storage is a reversed list; list.first() is the element with the highest ID / latest element
defmodule StorageHandler do
  def put_task(name) do
    case get_tasks() do
      nil ->
        PersistentStorage.put(:data, :tasks, [%{id: 1, name: name}])

      tasks ->
        # TODO: consider not allowing duplicate names
        new_tasks = [%{id: List.first(tasks).id + 1, name: name} | tasks]
        PersistentStorage.put(:data, :tasks, new_tasks)
    end

    IO.inspect(get_tasks())
  end

  def get_tasks(name \\ nil) do
    case name do
      nil ->
        PersistentStorage.get(:data, :tasks)

      name ->
        tasks = PersistentStorage.get(:data, :tasks)

        if tasks != nil do
          Enum.find(tasks, fn task_name -> name == task_name end)
        else
          nil
        end
    end
  end

  def put_tomato(task, timestamp \\ DateTime.utc_now()) do
    if get_tasks(task) == nil do
      put_task(task)
    end

    PersistentStorage.put(:data, :tomatoes, %{timestamp: timestamp, task: task})
  end

  def get_tomatoes(task \\ nil, timestamp \\ nil, id \\ nil) do
    PersistentStorage.get(:data, :tomatoes)
    |> Enum.filter(fn t ->
      cond do
        (task != nil and t.task != task) or (timestamp != nil and t.timestamp != timestamp) or
            (id != nil and t.id != id) ->
          false

        true ->
          true
      end
    end)
  end
end

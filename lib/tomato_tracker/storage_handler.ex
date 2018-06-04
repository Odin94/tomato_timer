# Storage is a reversed list; list.first() is the element with the highest ID / latest element
defmodule StorageHandler do
  use Timex

  def get_tomatoes_by_task_by_project(id \\ nil, name \\ nil) do
    tomatoes_by_task = get_tomatoes_by_task()

    tomatoes_by_task_by_project =
      get_projects()
      |> Enum.filter(fn proj ->
        cond do
          (id != nil and id != proj.id) or (name != nil and name != proj.name) ->
            false

          true ->
            true
        end
      end)
      |> Enum.map(fn proj ->
        Map.put(
          proj,
          :tasks,
          Enum.filter(tomatoes_by_task, fn task ->
            task.project == proj.id
          end)
        )
      end)
  end

  def get_tomatoes_by_task(id \\ nil, name \\ nil) do
    tomatoes = get_tomatoes()

    tomatoes_by_task =
      get_tasks()
      |> Enum.filter(fn task ->
        cond do
          (id != nil and id != task.id) or (name != nil and name != task.name) ->
            false

          true ->
            true
        end
      end)
      |> Enum.map(fn task ->
        Map.put(
          task,
          :tomatoes,
          Enum.filter(tomatoes, fn tomato ->
            tomato.task == task.id
          end)
        )
      end)
  end

  def get_projects(name \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :projects) do
      nil ->
        []

      projects ->
        Enum.filter(projects, fn p ->
          cond do
            # TODO: is there a better way to express this conditional? Doesn't look too pretty
            (name != nil and p.name != name) or (id != nil and p.id != id) ->
              false

            true ->
              true
          end
        end)
    end
  end

  def put_project(name) do
    case get_projects() do
      [] ->
        PersistentStorage.put(:data, :projects, [%{id: 1, name: name}])

      projects ->
        # TODO: consider not allowing duplicate names
        new_projects = [%{id: List.first(projects).id + 1, name: name} | projects]
        PersistentStorage.put(:data, :projects, new_projects)
    end
  end

  def update_project(id, new_name) do
    new_projects =
      Enum.map(get_projects(), fn proj ->
        if proj.id == id do
          %{proj | name: new_name}
        else
          proj
        end
      end)

    PersistentStorage.put(:data, :projects, new_projects)
  end

  def get_tasks(name \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :tasks) do
      nil ->
        []

      tasks ->
        Enum.filter(tasks, fn t ->
          cond do
            # TODO: is there a better way to express this conditional? Doesn't look too pretty
            (name != nil and t.name != name) or (id != nil and t.id != id) ->
              false

            true ->
              true
          end
        end)
    end
  end

  def put_task(name, project_id) do
    case get_tasks() do
      [] ->
        PersistentStorage.put(:data, :tasks, [%{id: 1, name: name, project: project_id}])

      tasks ->
        # TODO: consider not allowing duplicate names
        new_tasks = [%{id: List.first(tasks).id + 1, name: name, project: project_id} | tasks]
        PersistentStorage.put(:data, :tasks, new_tasks)
    end
  end

  def get_tomatoes(task \\ nil, timestamp \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :tomatoes) do
      nil ->
        []

      tomatoes ->
        Enum.filter(tomatoes, fn t ->
          cond do
            # TODO: is there a better way to express this conditional? Doesn't look too pretty
            (task != nil and t.task != task) or (timestamp != nil and t.timestamp != timestamp) or
                (id != nil and t.id != id) ->
              false

            true ->
              true
          end
        end)
    end
  end

  def put_tomato(task_id, summary \\ "", timestamp \\ Timex.now()) do
    case get_tomatoes() do
      [] ->
        PersistentStorage.put(:data, :tomatoes, [
          %{
            id: 1,
            task: task_id,
            summary: summary,
            timestamp: timestamp
          }
        ])

      tomatoes ->
        new_tomatoes = [
          %{id: List.first(tomatoes).id + 1, task: task_id, summary: summary, timestamp: timestamp}
          | tomatoes
        ]

        PersistentStorage.put(:data, :tomatoes, new_tomatoes)
    end
  end
end

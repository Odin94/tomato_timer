# Storage is a reversed list; list.first() is the element with the highest ID / latest element

# TODO: Tasks aren't displayed in frontend; check if we get them in this get function, then check if frontend might be buggy
defmodule StorageHandler do
  use Timex

  def get_tomatoes_by_task_by_project(id \\ nil, name \\ nil) do
    tomatoes_by_task = get_tomatoes_by_task()

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

  def delete_project(id) do
    delete_tasks(nil, id)

    new_projects =
      Enum.filter(get_projects(), fn proj ->
        proj.id != id
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

  @spec put_task(String.t(), integer) :: :ok | {:error, String.t()}
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

  @spec update_task(integer, String.t(), integer) :: :ok | {:error, String.t()}
  def update_task(id, new_name, new_project_id) do
    new_tasks =
      Enum.map(get_tasks(), fn task ->
        if task.id == id do
          %{task | name: new_name, project: new_project_id}
        else
          task
        end
      end)

    PersistentStorage.put(:data, :tasks, new_tasks)
  end

  def delete_tasks(id, project_id \\ nil)
  def delete_tasks(id, project_id) when id == nil and project_id == nil, do: :err

  def delete_tasks(id, project_id) do
    # filter by task-id
    new_tasks =
      if id != nil do
        Enum.filter(get_tasks(), fn task ->
          if(task.id != id) do
            true
          else
            delete_tomatoes(nil, id)
            false
          end
        end)

        # filter by project
      else
        Enum.filter(get_tasks(), fn task ->
          if(task.project != project_id) do
            true
          else
            IO.puts("delete tomatoes!!!!!!!!!!")
            delete_tomatoes(nil, task.id)
            false
          end
        end)
      end

    PersistentStorage.put(:data, :tasks, new_tasks)
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

  @spec put_tomato(integer, String.t, Timex.Types.valid_datetime) :: :ok | {:error, String.t()}
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
          %{
            id: List.first(tomatoes).id + 1,
            task: task_id,
            summary: summary,
            timestamp: timestamp
          }
          | tomatoes
        ]

        PersistentStorage.put(:data, :tomatoes, new_tomatoes)
    end
  end

  def delete_tomatoes(id, task_id \\ nil)
  def delete_tomatoes(id, task_id) when id == nil and task_id == nil, do: :err

  def delete_tomatoes(id, task_id) do
    new_tomatoes =
      if id != nil do
        Enum.filter(get_tomatoes(), fn tomato ->
          tomato.id != id
        end)

        # filter by task
      else
        Enum.filter(get_tomatoes(), fn tomato ->
          tomato.task != task_id
        end)
      end

    IO.inspect(new_tomatoes)
    PersistentStorage.put(:data, :tomatoes, new_tomatoes)
  end
end

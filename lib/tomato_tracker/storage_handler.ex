# Storage is a reversed list; list.first() is the element with the highest ID / latest element

# TODO: Tasks aren't displayed in frontend; check if we get them in this get function, then check if frontend might be buggy
defmodule StorageHandler do
  use Timex
  alias TomatoTracker.Types

  # [%{Types.project(), tasks: [%{Types.task(), tomatoes: [Types.tomato()]}]}]
  @spec get_tomatoes_by_task_by_project(Types.id() | nil, String.t() | nil) :: [any]
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

  @spec get_tomatoes_by_task(Types.id() | nil, String.t() | nil) :: [any]
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

  @spec get_projects(String.t() | nil, Types.id() | nil) :: [Types.project()]
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

  @spec put_project(String.t()) :: :ok | {:error, String.t()}
  def put_project(name) do
    case get_projects() do
      [] ->
        PersistentStorage.put(:data, :projects, [%{id: 1, name: name}])

      projects ->
        case Enum.any?(projects, fn proj -> name == proj.name end) do
          true ->
            {:error, "Project with name '#{name}' already exists."}

          false ->
            new_projects = [%{id: List.first(projects).id + 1, name: name} | projects]
            PersistentStorage.put(:data, :projects, new_projects)
        end
    end
  end

  @spec update_project(Types.id(), String.t()) :: :ok | {:error, String.t()}
  def update_project(id, new_name) do
    existing_projects = get_projects()

    case Enum.any?(existing_projects, fn proj -> proj.name == new_name end) do
      true ->
        {:error, "Project with name #{new_name} already exists."}

      false ->
        new_projects =
          Enum.map(existing_projects, fn proj ->
            if proj.id == id do
              %{proj | name: new_name}
            else
              proj
            end
          end)

        PersistentStorage.put(:data, :projects, new_projects)
    end
  end

  @spec delete_project(Types.id()) :: :ok | {:error, String.t()}
  def delete_project(id) do
    delete_tasks(nil, id)

    new_projects =
      Enum.filter(get_projects(), fn proj ->
        proj.id != id
      end)

    PersistentStorage.put(:data, :projects, new_projects)
  end

  @spec get_tasks(String.t() | nil, Types.id() | nil) :: [Types.task()]
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

  @spec put_task(String.t(), Types.id()) :: :ok | {:error, String.t()}
  def put_task(name, project_id) do
    case get_projects(nil, project_id) do
      [] ->
        {:error, "Project with id #{project_id} doesn't exist."}

      projects ->
        case get_tasks() do
          [] ->
            PersistentStorage.put(:data, :tasks, [%{id: 1, name: name, project: project_id}])

          tasks ->
            case Enum.any?(tasks, fn task -> project_id == task.project and name == task.name end) do
              true ->
                {:error, "Task with name '#{name}' already exists for this project."}

              false ->
                new_tasks = [
                  %{id: List.first(tasks).id + 1, name: name, project: project_id} | tasks
                ]

                PersistentStorage.put(:data, :tasks, new_tasks)
            end
        end
    end
  end

  @spec update_task(Types.id(), String.t(), Types.id()) :: :ok | {:error, String.t()}
  def update_task(id, new_name, new_project_id) do
    existing_tasks = get_tasks()

    case Enum.any?(existing_tasks, fn task ->
           task.name == new_name and task.project == new_project_id
         end) do
      true ->
        {:error,
         "Task with name '#{new_name}' already exists for project with id #{new_project_id}."}

      false ->
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
  end

  @spec delete_tasks(Types.id() | nil, Types.id() | nil) :: :ok | {:error, String.t()}
  def delete_tasks(id, project_id \\ nil)
  def delete_tasks(nil, nil), do: {:err, "id and project id can't both be nil"}

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

  @spec get_tomatoes(Types.id() | nil, Timex.Types.valid_datetime() | nil, Types.id() | nil) :: [
          Types.tomato()
        ]
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

  @spec put_tomato(Types.id(), String.t(), Timex.Types.valid_datetime()) ::
          :ok | {:error, String.t()}
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

  @spec delete_tomatoes(Types.id(), Types.id()) :: :ok | {:error, String.t()}
  def delete_tomatoes(id, task_id \\ nil)
  def delete_tomatoes(nil, nil), do: :err

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

# TODO: consider re-structuring to just one list of projects where each project contains tasks, which in turn contain tomatoes

# Storage is a reversed list; list.first() is the element with the highest ID / latest element
defmodule StorageHandler do
  def put_project(name) do
    case get_projects() do
      nil ->
        PersistentStorage.put(:data, :projects, [%{id: 1, name: name}])

      projects ->
        # TODO: consider not allowing duplicate names
        new_projects = [%{id: List.first(projects).id + 1, name: name} | projects]
        PersistentStorage.put(:data, :projects, new_projects)
    end
  end

  def get_projects(name \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :projects) do
      nil ->
        nil

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

  def put_task(name, project) do
    case get_tasks() do
      nil ->
        PersistentStorage.put(:data, :tasks, [%{id: 1, name: name, project: project}])

      tasks ->
        # TODO: consider not allowing duplicate names
        new_tasks = [%{id: List.first(tasks).id + 1, name: name, project: project} | tasks]
        PersistentStorage.put(:data, :tasks, new_tasks)
    end
  end

  def get_tasks(name \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :tasks) do
      nil ->
        nil

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

  def put_tomato(task, summary \\ "", timestamp \\ DateTime.utc_now(), project \\ "general") do
    if get_tasks(task) == nil do
      put_task(task, project)
    end

    case get_tomatoes() do
      nil ->
        PersistentStorage.put(:data, :tomatoes, [
          %{
            id: 1,
            task: task,
            summary: summary,
            timestamp: timestamp
          }
        ])

      tomatoes ->
        new_tomatoes = [
          %{id: List.first(tomatoes).id + 1, task: task, summary: summary, timestamp: timestamp}
          | tomatoes
        ]

        PersistentStorage.put(:data, :tomatoes, new_tomatoes)
    end
  end

  def get_tomatoes(task \\ nil, timestamp \\ nil, id \\ nil) do
    case PersistentStorage.get(:data, :tomatoes) do
      nil ->
        nil

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
end

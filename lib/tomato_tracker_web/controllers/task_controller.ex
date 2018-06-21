defmodule TomatoTrackerWeb.TaskController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"task" => %{"name" => name, "project" => project}}) do
    project_id = String.to_integer(project)

    case StorageHandler.put_task(name, project_id) do
      :ok ->
        conn
        |> put_flash(:info, "Task #{name} created.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))

      {:error, msg} ->
        conn
        |> put_flash(:error, "Failed to create task: #{msg}")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end

  def update(conn, %{
        "id" => task_id,
        "task" => %{"name" => new_task_name, "project_id" => new_project_id}
      }) do
    task_id = String.to_integer(task_id)
    new_project_id = String.to_integer(new_project_id)

    case StorageHandler.update_task(task_id, new_task_name, new_project_id) do
      :ok ->
        conn
        |> put_flash(:info, "Updated task #{new_task_name}.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))

      {:error, msg} ->
        conn
        |> put_flash(:error, "Failed to update task: #{msg}")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end

  def delete(conn, %{"id" => task_id}) do
    task_id = String.to_integer(task_id)
    StorageHandler.delete_tasks(task_id)

    conn
    |> put_flash(:info, "Deleted task #{task_id}.")
    |> put_status(303)
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end
end

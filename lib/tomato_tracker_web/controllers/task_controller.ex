defmodule TomatoTrackerWeb.TaskController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"task" => %{"name" => name, "project" => project}}) do
    # TODO: create project if doesn't exist or display error?
    project = String.to_integer(project)

    StorageHandler.put_task(name, project)
    IO.inspect(project)

    conn
    |> put_flash(:info, "Task #{name} created.")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end

  def update(conn, %{
        "id" => task_id,
        "task" => %{"name" => new_task_name, "project_id" => new_project_id}
      }) do
    task_id = String.to_integer(task_id)
    new_project_id = String.to_integer(new_project_id)
    StorageHandler.update_task(task_id, new_task_name, new_project_id)

    conn
    |> put_flash(:info, "Updated task #{new_task_name}.")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
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

defmodule TomatoTrackerWeb.ProjectController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", projects: StorageHandler.get_tomatoes_by_task_by_project())
  end

  def new(conn, _params) do
    render(conn, "new.html", projects: StorageHandler.get_tomatoes_by_task_by_project())
  end

  def create(conn, %{"project" => %{"name" => name}}) do
    StorageHandler.put_project(name)

    conn
    |> put_flash(:info, "Created project #{name}.")
    |> redirect(to: NavigationHistory.last_path(conn, [default: "/"]))
  end

  # TODO: move this to project-controller & make one for tasks as well
  def show(conn, %{"id" => project_id}) do
    render(conn, "show.html", project: StorageHandler.get_tomatoes_by_task_by_project(project_id))
  end
end

defmodule TomatoTrackerWeb.ProjectController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    render(
      conn,
      "index.html",
      projects: StorageHandler.get_tomatoes_by_task_by_project(),
      tasks: StorageHandler.get_tasks()
    )
  end

  def new(conn, _params) do
    render(conn, "new.html", projects: StorageHandler.get_tomatoes_by_task_by_project())
  end

  def create(conn, %{"project" => %{"name" => name}}) do
    case StorageHandler.put_project(name) do
      :ok ->
        conn
        |> put_flash(:info, "Created project #{name}.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))

      {:error, msg} ->
        conn
        |> put_flash(:error, "Creating project failed: #{msg}")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end

  def show(conn, %{"id" => project_id}) do
    project_id = String.to_integer(project_id)

    case StorageHandler.get_tomatoes_by_task_by_project(project_id) do
      [] ->
        conn
        |> put_status(:not_found)
        |> put_view(TomatoTrackerWeb.ErrorView)
        |> render("404.html")

      [project] ->
        render(conn, "show.html", project: project)
    end
  end

  def update(conn, %{"id" => project_id, "project" => %{"name" => new_project_name}}) do
    project_id = String.to_integer(project_id)

    case StorageHandler.update_project(project_id, new_project_name) do
      :ok ->
        conn
        |> put_flash(:info, "Updated project #{new_project_name}.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))

      {:error, msg} ->
        conn
        |> put_flash(:error, "Failed to update project: #{msg}")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end

  def delete(conn, %{"id" => project_id}) do
    project_id = String.to_integer(project_id)
    StorageHandler.delete_project(project_id)

    conn
    |> put_flash(:info, "Deleted project #{project_id}.")
    |> put_status(303)
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end
end

defmodule TomatoTrackerWeb.TaskController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"task" => %{"name" => name, "project" => project}}) do
    # TODO: create project if doesn't exist or display error?
    StorageHandler.put_task(name, project)
    IO.inspect(project)

    conn
    |> put_flash(:info, "Task #{name} created.")
    |> redirect(to: NavigationHistory.last_path(conn, [default: "/"]))
  end
end

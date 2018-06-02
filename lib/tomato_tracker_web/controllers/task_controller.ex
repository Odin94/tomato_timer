defmodule TomatoTrackerWeb.TaskController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"task" => %{"name" => name, "project" => project}}) do
    # TODO: create project if doesn't exist or display error?
    StorageHandler.put_task(name, project)

    conn
    |> put_flash(:info, "Task #{name} created.")
    |> redirect(to: "/")
  end
end

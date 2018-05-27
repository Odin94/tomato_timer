defmodule TomatoTrackerWeb.PageController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    StorageHandler.put_task("test_task")
    StorageHandler.get_tasks("some_name")

    render(conn, "index.html")
  end
end

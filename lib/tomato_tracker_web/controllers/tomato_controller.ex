defmodule TomatoTrackerWeb.TomatoController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, params) do
    redirect(conn, to: "/")
  end

  def create(conn, %{"tomato" => %{"task" => task}}) do
    StorageHandler.put_tomato(task)
    IO.inspect(StorageHandler.get_tomatoes)

    redirect(conn, to: "/")
  end
end

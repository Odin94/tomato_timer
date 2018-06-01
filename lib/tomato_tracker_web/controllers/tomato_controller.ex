defmodule TomatoTrackerWeb.TomatoController do
  use TomatoTrackerWeb, :controller
  use Timex

  def index(conn, _params) do
    render(conn, "index.html", tasks: StorageHandler.get_tomatoes_by_task())
  end

  def new(conn, _params) do
    redirect(conn, to: "/")
  end

  def create(conn, %{"tomato" => %{"task" => task, "summary" => summary, "datetime" => datetime}}) do
    case Timex.parse(datetime, "{YYYY}-{0M}-{0D} {h24}:{m}") do
      {:error, msg} ->
        StorageHandler.put_tomato(task, summary)

      {:ok, parsed_time} ->
        StorageHandler.put_tomato(task, summary, Timex.to_datetime(parsed_time))
    end

    redirect(conn, to: "/")
  end
end

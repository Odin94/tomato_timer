defmodule TomatoTrackerWeb.TomatoController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"tomato" => %{"task" => task, "summary" => summary, "datetime" => datetime}}) do
    task = String.to_integer(task)

    case Timex.parse(datetime, "{YYYY}-{0M}-{0D} {h24}:{m}") do
      {:error, _} ->
        StorageHandler.put_tomato(task, summary)

      {:ok, parsed_time} ->
        StorageHandler.put_tomato(task, summary, Timex.to_datetime(parsed_time))
    end

    conn
    |> put_flash(:info, "Tomato created.")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end

  def delete(conn, %{"id" => tomato_id}) do
    tomato_id = String.to_integer(tomato_id)
    StorageHandler.delete_tomatoes(tomato_id)

    conn
    |> put_flash(:info, "Deleted tomato #{tomato_id}.")
    |> put_status(303)
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end
end

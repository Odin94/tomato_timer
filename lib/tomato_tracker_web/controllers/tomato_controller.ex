defmodule TomatoTrackerWeb.TomatoController do
  use TomatoTrackerWeb, :controller
  use Timex

  def create(conn, %{"tomato" => %{"task" => task, "summary" => summary, "datetime" => datetime}}) do
    case Timex.parse(datetime, "{YYYY}-{0M}-{0D} {h24}:{m}") do
      {:error, msg} ->
        StorageHandler.put_tomato(task, summary)

      {:ok, parsed_time} ->
        StorageHandler.put_tomato(task, summary, Timex.to_datetime(parsed_time))
    end

    conn
    |> put_flash(:info, "Tomato created.")
    |> redirect(to: "/")
  end
end

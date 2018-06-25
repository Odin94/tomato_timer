defmodule TomatoTrackerWeb.QuotaTrackerController do
  use TomatoTrackerWeb, :controller

  def update(conn, %{
        "quota_target" => quota_target,
        "start_time" => start_time,
        "interval_amount" => interval_amount,
        "interval_unit" => interval_unit
      }) do
    interval_unit = String.to_atom(interval_unit)
    interval_amount = String.to_integer(interval_amount)
    quota_target = String.to_integer(quota_target)

    with {:ok, parsed_time} <- Timex.parse(start_time, "{YYYY}-{0M}-{0D} {h24}:{m}"),
         :ok <- QuotaTracker.set_start_time(parsed_time),
         :ok <- QuotaTracker.set_interval_length(interval_amount, interval_unit),
         :ok <- QuotaTracker.set_target(quota_target) do
      conn
      |> put_flash(:info, "Updated quota tracker config.")
      |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    else
      {:error, msg} ->
        conn
        |> put_flash(:error, "Failed to update quota tracker config: #{msg}")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))

      _ ->
        conn
        |> put_flash(:error, "Failed to update quota tracker config with unknown error.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end
end

defmodule Backup do
  @spec backup() :: :ok | {:error, String.t()}
  def backup() do
    backup_dest = "#{Application.get_env(:tomato_tracker, TomatoTrackerWeb.Endpoint)[:backup_path]}/#{Timex.Duration.to_string(Timex.Duration.epoch())}"
    File.mkdir_p(backup_dest)
    File.cp_r("./storage/data", backup_dest)
  end

  @spec restore(String.t) :: :ok | {:error, String.t()}
  def restore(from_path) do
    # TODO: use :ets.delete(:table_name) to clear cache
    File.cp_r(from_path, "./storage/data")
  end
end

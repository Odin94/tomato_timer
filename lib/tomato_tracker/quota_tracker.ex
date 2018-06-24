defmodule QuotaTracker do
  @moduledoc """
  Tracks amount of tomatoes done compared to a set target amount of tomatoes for
  a set interval of time.
  """
  alias TomatoTracker.Types
  import Timex.Duration, only: [to_seconds: 1, to_seconds: 2]

  # @spec get_quota_progress() :: non_neg_integer | nil
  def get_quota_progress() do
    PersistentStorage.get(:data, :quota_current)
  end

  # @spec update_quota_progress(non_neg_integer) :: :ok | {:error, String.t()}
  def update_quota_progress() do
    update_start_time()

    current_tomato_count =
      StorageHandler.get_tomatoes()
      |> Enum.filter(fn tomato -> in_current_interval?(tomato.timestamp) end)
      |> length

    IO.puts(current_tomato_count)
    PersistentStorage.put(:data, :quota_current, current_tomato_count)
  end

  @spec in_current_interval?(non_neg_integer | float) :: boolean | {:error, String.t()}
  defp in_current_interval?(timestamp) do
    start_time = get_start_time()

    Timex.between?(timestamp, start_time, Timex.shift(start_time, get_interval_length()))
  end

  @spec get_target() :: non_neg_integer | nil
  def get_target() do
    PersistentStorage.get(:data, :quota_target)
  end

  @spec set_target(non_neg_integer) :: :ok | {:error, String.t()}
  def set_target(target) do
    PersistentStorage.put(:data, :quota_target, target)
  end

  def update_start_time() do
    # TODO: check if start_time > start_time + interval, update if needed
  end

  @spec get_start_time() :: Timex.Types.valid_datetime() | nil
  def get_start_time() do
    PersistentStorage.get(:data, :quota_start_time)
  end

  @spec set_start_time(Timex.Types.valid_datetime()) :: :ok | {:error, String.t()}
  def set_start_time(start_time) do
    PersistentStorage.put(:data, :quota_start_time, start_time)
  end

  @spec get_interval_length() :: Types.quota_interval() | nil
  def get_interval_length() do
    PersistentStorage.get(:data, :quota_interval)
  end

  @spec set_interval_length(non_neg_integer, Types.interval_unit()) :: :ok | {:error, String.t()}
  def set_interval_length(amount, unit) do
    PersistentStorage.put(:data, :quota_interval, [{unit, amount}])
  end
end

defmodule QuotaTracker do
  @moduledoc """
  Tracks amount of tomatoes done compared to a set target amount of tomatoes for
  a set interval of time.
  """
  alias TomatoTracker.Types

  def get_start_time() do
  end

  def set_start_time() do
  end

  @spec get_interval_length() :: Types.quota_interval | nil
  def get_interval_length() do
    PersistentStorage.get(:data, :quota_interval)
  end

  @spec set_interval_length(non_neg_integer, Types.interval_unit()) :: :ok | {:error, String.t()}
  def set_interval_length(amount, unit) do
    PersistentStorage.put(:data, :quota_interval, %{amount: amount, unit: unit})
  end
end

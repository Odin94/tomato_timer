defmodule TomatoTracker.Types do
  @moduledoc """
  Custom types for TomatoTracker data
  """
  alias Timex.Types

  # type-aliases
  @type id :: non_neg_integer

  # struct types
  @type tomato :: %{id: id, task: id, summary: String.t(), timestamp: Types.valid_datetime()}
  @type task :: %{id: id, name: String.t(), project: id}
  @type project :: %{id: id, name: String.t()}

  # quota tracker types
  @type interval_unit :: :days | :weeks | :months | :years
  @type quota_interval :: %{amount: non_neg_integer, unit: interval_unit}
end

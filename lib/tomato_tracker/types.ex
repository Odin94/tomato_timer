defmodule TomatoTracker.Types do
  alias Timex.Types

  # type-aliases
  @type id :: non_neg_integer

  # struct types
  @type tomato :: %{id: id, task: id, summary: String.t, timestamp: Types.valid_datetime}
  @type task :: %{id: id, name: String.t, project: id}
  @type project :: %{id: id, name: String.t}
end

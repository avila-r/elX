defmodule X.Utils do
  def get_field(struct, field) do
    case struct[field] do
      nil -> {:error, "field #{field} is required"}
      value -> {:ok, value}
    end
  end

  def is_integer(value) do
    case Integer.parse(value) do
      {integer, _msg} -> {:ok, integer}
      _ -> {:error, "value #{value} isn't an integer"}
    end
  end
end

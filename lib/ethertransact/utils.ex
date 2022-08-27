defmodule Ethertransact.Utils do
  @doc """
  converts string keys on a map from camelcase to underscores.
  """
  def convert_string_keys_to_underscores(transactions) do
    transactions
    |> Enum.map(fn {key, value} -> {Macro.underscore(key), value} end)
    |> Enum.into(%{})
  end

  @doc """
  converts values from hexadecimal to decimal
  """
  def convert_hex_to_decimal("0x" <> hex) do
    {int, _} = Integer.parse(hex, 16)
    int
  end
end

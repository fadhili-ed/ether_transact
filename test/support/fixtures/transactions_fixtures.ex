defmodule Ethertransact.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ethertransact.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        "block_hash" => "0xbaee22af41ce5cb4d28a6a377da26f4fc4f9d893fdfaa6878fb732f42367a947",
        "block_number" => "0x4b9b05",
        "from" => "0x0fe426d8f95510f4f0bac19be5e1252c4127ee00",
        "hash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
        "complete" => false,
        "to" => "0x4848535892c8008b912d99aaf88772745a11c809",
        "value" => "0x526e615a87b5000"
      })
      |> Ethertransact.Transactions.create_transaction()

    transaction
  end
end

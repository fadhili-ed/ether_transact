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
        block_hash: "some block_hash",
        block_number: 42,
        from: "some from",
        hash: "some hash",
        status: "some status",
        to: "some to",
        value: "some value"
      })
      |> Ethertransact.Transactions.create_transaction()

    transaction
  end
end

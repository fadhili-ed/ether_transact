defmodule Ethertransact.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Ethertransact.Repo

  alias Ethertransact.Transactions.Transaction
  alias Ethertransact.Utils

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    attrs = transform_transaction_params(attrs)

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  This functions transform the transaction params into a suitable form
  that the changeset will accept.
  """
  def transform_transaction_params(attrs) do
    attrs
    |> Utils.convert_string_keys_to_underscores()
    |> convert_block_number_to_decimal()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  @doc """
  Performs update to incomplete transactions changing transactions whose block confirmations
  are greater than or equal to 2 to complete.
  """
  def update_pending_transactions_to_complete(block_number) do
    block_number
    |> Transaction.update_pending_transaction_query()
    |> Repo.update_all([])
  end

  defp convert_block_number_to_decimal(%{"block_number" => block_number} = attrs) do
    Map.replace(attrs, "block_number", Utils.convert_hex_to_decimal(block_number))
  end

  defp convert_block_number_to_decimal(attrs) do
    attrs
  end
end

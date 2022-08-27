defmodule Ethertransact.TransactionsTest do
  use Ethertransact.DataCase

  alias Ethertransact.Transactions

  describe "transactions" do
    alias Ethertransact.Transactions.Transaction

    import Ethertransact.TransactionsFixtures

    @invalid_attrs %{
      block_hash: nil,
      block_number: nil,
      from: nil,
      hash: nil,
      status: nil,
      to: nil,
      value: nil
    }

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        block_hash: "some block_hash",
        block_number: 42,
        from: "some from",
        hash: "some hash",
        status: "some status",
        to: "some to",
        value: "some value"
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.block_hash == "some block_hash"
      assert transaction.block_number == 42
      assert transaction.from == "some from"
      assert transaction.hash == "some hash"
      assert transaction.status == "some status"
      assert transaction.to == "some to"
      assert transaction.value == "some value"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        block_hash: "some updated block_hash",
        block_number: 43,
        from: "some updated from",
        hash: "some updated hash",
        status: "some updated status",
        to: "some updated to",
        value: "some updated value"
      }

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.block_hash == "some updated block_hash"
      assert transaction.block_number == 43
      assert transaction.from == "some updated from"
      assert transaction.hash == "some updated hash"
      assert transaction.status == "some updated status"
      assert transaction.to == "some updated to"
      assert transaction.value == "some updated value"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end

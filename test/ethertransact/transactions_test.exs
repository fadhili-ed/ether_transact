defmodule Ethertransact.TransactionsTest do
  use Ethertransact.DataCase

  alias Ethertransact.Transactions

  describe "transactions" do
    alias Ethertransact.Transactions.Transaction

    @valid_attrs %{
      "blockHash" => "0xbaee22af41ce5cb4d28a6a377da26f4fc4f9d893fdfaa6878fb732f42367a947",
      "blockNumber" => "0x4b9b05",
      "from" => "0x0fe426d8f95510f4f0bac19be5e1252c4127ee00",
      "gas" => "0x5208",
      "gasPrice" => "0x4a817c800",
      "hash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
      "input" => "0x",
      "nonce" => "0x2",
      "r" => "0xb0a50a9b5e11e36e564d985f3590173a40f231a04c6bfd6132d87244b5b45bcb",
      "s" => "0xa936a6f53d7e001a5f5ba6ca182e7e204a7ed0b8c5a7b874041a179d6e1e994",
      "to" => "0x4848535892c8008b912d99aaf88772745a11c809",
      "transactionIndex" => "0xa0",
      "type" => "0x0",
      "v" => "0x25",
      "value" => "0x526e615a87b5000"
    }

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
      {:ok, transaction} = Transactions.create_transaction(@valid_attrs)
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      {:ok, transaction} = Transactions.create_transaction(@valid_attrs)
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction.block_hash == "0xbaee22af41ce5cb4d28a6a377da26f4fc4f9d893fdfaa6878fb732f42367a947"
      assert transaction.block_number == 4954885
      assert transaction.from == "0x0fe426d8f95510f4f0bac19be5e1252c4127ee00"
      assert transaction.hash == "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
    end

    test "update_incomplete_transactions/1" do
      insert_complete_and_incomplete_transactions()
      assert {5, nil} == Transactions.update_pending_transactions_to_complete(7)
    end

    defp insert_complete_and_incomplete_transactions do
      1..9
      |> Enum.map(fn decimal ->
        %{
          "block_hash" => "some block_hash",
          "block_number" => "#{convert_decimal_to_hex(decimal)}",
          "complete" => false,
          "from" => "from",
          "gas" => "gas",
          "gas_price" => "gas price",
          "hash" => "#{convert_decimal_to_hex(decimal)}",
          "input" => "0x",
          "nonce" => "0x2",
          "to" => "0x484853",
          "transaction_index" => "0xa0",
          "value" => "0x526e"
        }
        |> Transactions.create_transaction()
      end)

      Transactions.create_transaction(@valid_attrs)
    end

    defp convert_decimal_to_hex(decimal) do
      "0x#{Integer.to_string(decimal, 16)}"
    end
  end
end

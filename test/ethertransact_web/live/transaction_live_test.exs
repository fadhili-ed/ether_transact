defmodule EthertransactWeb.TransactionLiveTest do
  use EthertransactWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ethertransact.TransactionsFixtures

  @hash "0x9b37a571fdd82718aaaaf485c59d48050d59339e607023101dffee9944c52aa5"

  defp create_transaction(_) do
    transaction = transaction_fixture()
    %{transaction: transaction}
  end

  describe "Index" do
    setup [:create_transaction]

    test "lists all transactions", %{conn: conn, transaction: transaction} do
      {:ok, _index_live, html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Listing Transactions"
      assert html =~ transaction.block_hash
    end

    test "saves new transaction", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("a", "New Transaction") |> render_click() =~
               "New Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :new))

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: %{hash: @hash})
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction receieved successfully"
      assert html =~ @hash
    end
  end
end

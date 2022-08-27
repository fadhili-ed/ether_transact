defmodule EthertransactWeb.TransactionLive.Index do
  use EthertransactWeb, :live_view

  alias Ethertransact.Transactions
  alias Ethertransact.Transactions.Transaction

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :transactions, list_transactions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  defp list_transactions do
    Transactions.list_transactions()
  end
end

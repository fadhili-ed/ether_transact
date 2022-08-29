defmodule EthertransactWeb.TransactionLive.Index do
  use EthertransactWeb, :live_view

  alias Ethertransact.Transactions
  alias Ethertransact.Transactions.Transaction

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Transactions.subscribe()
    {:ok, assign(socket, :transactions, list_transactions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:ok, :transaction}, socket) do
    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Enter transaction hash")
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

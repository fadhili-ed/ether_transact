defmodule EthertransactWeb.TransactionLive.FormComponent do
  use EthertransactWeb, :live_component

  alias Ethertransact.EtherTransactApi
  alias Ethertransact.Transactions

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :new, transaction_params) do
    %{"hash" => tx_hash} = transaction_params

    case EtherTransactApi.fetch_transaction_by_hash(tx_hash) do
      {:ok, transaction} ->
        create_transaction(socket, transaction)

      {:error,
       %Ecto.Changeset{
         errors: [
           hash: {"has already been taken", [constraint: :unique]}
         ]
       }} ->
        {:noreply,
         socket
         |> put_flash(:error, "Transaction has already been entered!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Oops, a problem occured, please try again")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp create_transaction(socket, transaction) do
    with {:ok, _transaction} <- Transactions.create_transaction(transaction) do
      {:noreply,
       socket
       |> put_flash(:info, "Transaction receieved successfully")
       |> push_redirect(to: socket.assigns.return_to)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

defmodule Ethertransact.ConfirmTransaction do
  use GenServer, restart: :transient

  alias Ethertransact.EtherTransactApi
  alias Ethertransact.Repo
  alias Ethertransact.Transactions
  alias Ethertransact.Transactions.Transaction
  alias Ethertransact.Utils

  @update_interval 10000

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(state) do
    schedule_work(:confirm_transaction_payment)

    {:ok, state}
  end

  @impl true
  def handle_info(:confirm_transaction_payment, state) do
    case EtherTransactApi.fetch_most_recent_block_number() do
      {:ok, block_number} ->
        pending_transactions = Transaction.pending_transactions() |> Repo.all()

        if pending_transactions == [] do
          {:stop, :normal, state}
        else
          block_number = Utils.convert_hex_to_decimal(block_number)

          confirm_transactions(block_number)

          schedule_work(:confirm_transaction_payment)
          {:noreply, state}
        end

      {:error, message} ->
        {:noreply, message}
    end
  end

  def schedule_work(message) do
    Process.send_after(self(), message, @update_interval)
  end

  def confirm_transactions(block_number) do
    Transactions.update_pending_transactions_to_complete(block_number)
  end
end

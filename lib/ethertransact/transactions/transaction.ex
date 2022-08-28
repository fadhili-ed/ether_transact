defmodule Ethertransact.Transactions.Transaction do
  @doc """
  Schema for Transactions
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "transactions" do
    field :hash, :string
    field :block_hash, :string
    field :block_number, :integer
    field :from, :string
    field :complete, :boolean, default: false
    field :to, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:hash, :from, :to, :block_hash, :block_number, :value, :complete])
    |> unique_constraint([:hash])
  end

  def update_pending_transaction_query(block_number) do
    from(t in __MODULE__,
      where: t.complete == false and ^block_number - t.block_number >= 2,
      update: [set: [complete: true]]
    )
  end

  def pending_transactions do
    from(t in __MODULE__, where: t.complete == false)
  end
end

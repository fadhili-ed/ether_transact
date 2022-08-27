defmodule Ethertransact.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :hash, :string
      add :from, :string
      add :to, :string
      add :block_hash, :string
      add :block_number, :integer
      add :value, :string
      add :complete, :boolean, default: false

      timestamps()
    end

    create unique_index("transactions", [:hash])
  end
end

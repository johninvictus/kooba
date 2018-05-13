defmodule KoobaServer.Repo.Migrations.CreateWalletAccounts do
  use Ecto.Migration

  def change do
    create table(:wallet_accounts) do
      add(:phone, :string, null: false)
      add(:amount, :moneyz, null: false)

      timestamps()
    end
  end
end

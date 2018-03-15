defmodule KoobaServer.Repo.Migrations.CreateLoanPayments do
  use Ecto.Migration

  def change do
    create table(:loan_payments) do
      add :payment_schedue, :string, null: false
      add :type, :string, null: false
      add :amount, :string, null: false
      add :status, :string, null: false
      add :notified_count, :integer, null: false

      add :loans_taken_id, references(:loans_taken, on_delete: :delete_all)

      timestamps()
    end

    create index(:loan_payments, [:loans_taken_id])
  end
end

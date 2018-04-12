defmodule KoobaServer.Repo.Migrations.CreateLoanPayments do
  use Ecto.Migration

  def change do
    create table(:loan_payments) do
      add(:payment_schedue, :naive_datetime, null: false)
      add(:type, :string, null: false)

      add(:amount, :moneyz, null: false)
      add(:payment_remaining, :moneyz, null: false)

      add(:status, :string, null: false)
      add(:notified_count, :integer, null: false)

      add(:loan_taken_id, references(:loan_taken, on_delete: :delete_all))

      timestamps()
    end

    create(index(:loan_payments, [:loan_taken_id]))
  end
end

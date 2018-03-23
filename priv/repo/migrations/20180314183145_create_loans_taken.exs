defmodule KoobaServer.Repo.Migrations.CreateLoansTaken do
  use Ecto.Migration

  def change do
    create table(:loan_taken) do
      add :status, :string, null: false
      add :loan_amount, :moneyz, null: false
      add :loan_interest, :moneyz, null: false
      add :late_fee, :moneyz, null: false
      add :loan_total, :moneyz, null: false
      add :notified_count, :integer, null: false
      add :next_payment_id, :integer, null: false

      add :user_id, references(:users, on_delete: :delete_all)
      add :loan_setting_id, references(:loan_settings, on_delete: :delete_all)

      timestamps()
    end

    create index(:loan_taken, [:user_id])
    create index(:loan_taken, [:loan_setting_id])
  end
end

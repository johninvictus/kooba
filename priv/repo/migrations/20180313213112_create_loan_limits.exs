defmodule KoobaServer.Repo.Migrations.CreateLoanLimits do
  use Ecto.Migration

  def change do
    create table(:loan_limits) do
      add :amount, :integer
      add :status, :string
      add :suspended_until, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:loan_limits, [:user_id])
  end
end

defmodule KoobaServer.Repo.Migrations.CreateLoanLimits do
  use Ecto.Migration

  def change do

    # create type
    execute("""
    CREATE TYPE moneyz AS (
    cents integer,
    currently varchar
    );
    """)

    create table(:loan_limits) do
      add :amount, :moneyz
      add :status, :string, null: false
      add :suspended_until, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:loan_limits, [:user_id])
  end
end

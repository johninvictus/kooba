defmodule KoobaServer.Repo.Migrations.CreateLoanSettings do
  use Ecto.Migration

  def change do
    create table(:loan_settings) do
      add :term_measure, :string, null: false
      add :frequency, :integer, null: false
      add :term, :integer, null: false
      add :interest, :integer, null: false
      add :late_interest, :integer, null: false

      timestamps()
    end

  end
end

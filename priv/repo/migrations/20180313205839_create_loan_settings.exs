defmodule KoobaServer.Repo.Migrations.CreateLoanSettings do
  use Ecto.Migration

  def change do
    create table(:loan_settings) do
      add :term_measure, :string
      add :frequency, :integer
      add :term, :integer
      add :interest, :integer
      add :late_interest, :integer

      timestamps()
    end

  end
end

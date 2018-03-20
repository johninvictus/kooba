defmodule KoobaServer.Repo.Migrations.CreateLoanSettings do
  use Ecto.Migration

  def change do
    create table(:loan_settings) do
      add :name, :string, null: false # will be used to identify
      add :term_measure, :string, null: false #weekly or monthly
      add :frequency, :integer, null: false # 1, 2, 3 of payment
      add :term, :integer, null: false # 28 days
      add :interest, :integer, null: false
      add :late_interest, :integer, null: false
      add :min_amount, :moneyz, null: false

      timestamps()
    end

  end
end

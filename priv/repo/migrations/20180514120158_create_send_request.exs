defmodule KoobaServer.Repo.Migrations.CreateSendMoneyRequest do
  use Ecto.Migration

  def change do
    create table(:send_money_request) do
      add(:convertion_id, :string, null: false)
      add(:originator_conversation_id, :string, null: false)
      add(:status, :string, null: false)
      add(:receipt, :string)

      add(:loan_taken_id, references(:loan_taken, on_delete: :nothing))

      timestamps()
    end

    create(index(:send_money_request, [:loan_taken_id]))
  end
end

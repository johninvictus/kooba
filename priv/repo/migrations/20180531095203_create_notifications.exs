defmodule KoobaServer.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add(:message, :string)
      add(:json_body, :string)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:notifications, [:user_id]))
  end
end

defmodule KoobaServer.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string, null: false
      add :device_token, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:devices, [:user_id])
    create unique_index(:devices, [:device_token])
  end
end

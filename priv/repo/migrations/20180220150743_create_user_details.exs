defmodule KoobaServer.Repo.Migrations.CreateUserDetails do
  use Ecto.Migration

  def change do
    create table(:user_details) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:national_card, :integer, null: false)
      add(:full_name, :string, null: false)
      add(:birth_date, :string, null: false)

      timestamps()
    end

    create(index(:user_details, [:user_id]))
    create(unique_index(:user_details, [:national_card]))
  end
end

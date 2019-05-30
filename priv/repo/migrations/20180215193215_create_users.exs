defmodule KoobaServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do

    # create type
    execute("""
    CREATE TYPE moneyz AS (
    cents integer,
    currently varchar
    );
    """)


    create table(:users) do
      # will save number with the plus
      add(:phone, :string, null: false)
      add(:country_prefix, :integer, null: false)
      add(:national_number, :integer, null: false)

      add(:access_token, :string)

      add :user_type, :integer, default: 2
      add :active, :boolean, default: false
      add :password, :string, default: ""
      add :card_provided, :boolean, default: false

      timestamps()
    end

    create(unique_index(:users, [:phone]))
    create(unique_index(:users, [:national_number]))
  end
end

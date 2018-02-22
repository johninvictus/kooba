defmodule KoobaServer.Accounts.UserDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.Accounts.UserDetail

  schema "user_details" do
    field(:national_card, :integer)
    field(:full_name, :string)
    field(:birth_date, :string)

    belongs_to(:user, KoobaServer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%UserDetail{} = user_detail, attrs) do
    user_detail
    |> cast(attrs, [:user_id, :national_card, :first_name, :second_name])
    |> validate_required([:user_id, :national_card, :first_name, :second_name])
    |> validate_length(:national_card, min: 6, max: 8)
    |> unique_constraint(:national_card)
    |> assoc_constraint(:user)
  end
end

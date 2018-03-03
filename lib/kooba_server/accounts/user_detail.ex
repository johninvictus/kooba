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
    |> cast(attrs, [:user_id, :national_card, :full_name, :birth_date])
    |> validate_required([:user_id, :national_card, :full_name, :birth_date])
    |> unique_constraint(:national_card)
    |> assoc_constraint(:user)
  end
end

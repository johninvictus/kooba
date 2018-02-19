defmodule KoobaServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.Accounts.User


  schema "users" do
    field :access_token, :string
    field :phone, :string
    field :country_prefix, :integer
    field :national_number, :integer

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone, :access_token, :country_prefix, :national_number ])
    |> validate_required([:phone, :access_token])
    |> unique_constraint(:phone)
    |> unique_constraint(:national_number)
  end
end
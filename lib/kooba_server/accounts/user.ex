defmodule KoobaServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.Accounts.User
  alias KoobaServer.MicroFinance.LoanLimit

  schema "users" do
    field(:access_token, :string)
    field(:phone, :string)
    field(:country_prefix, :integer)
    field(:national_number, :integer)

    has_one(:user_details, KoobaServer.Accounts.UserDetail)
    has_one(:loan_limit, KoobaServer.MicroFinance.LoanLimit)
    has_many(:loans, KoobaServer.MicroFinance.LoanTaken)
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone, :access_token, :country_prefix, :national_number])
    |> validate_required([:phone, :access_token])
    |> unique_constraint(:phone)
  end

  def build(attrs \\ Map.new) do
    changeset(%User{}, attrs)
    |> put_assoc(:loan_limit, LoanLimit.build_initial_limit())
  end
end

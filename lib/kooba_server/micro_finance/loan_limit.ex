defmodule KoobaServer.MicroFinance.LoanLimit do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanLimit


  schema "loan_limits" do
    field :amount, :integer
    field :status, :string
    field :suspended_until, :string

    belongs_to(:user, KoobaServer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%LoanLimit{} = loan_limit, attrs) do
    loan_limit
    |> cast(attrs, [:amount, :status, :suspended_until])
    |> validate_required([:amount, :status, :suspended_until])
  end
end

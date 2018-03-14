defmodule KoobaServer.MicroFinance.LoanLimit do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanLimit

 @status_includes ~w(active suspended)

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
    |> validate_inclusion(:status, @status_includes)
    |> assoc_constraint(:user)
  end

  def build_initial_limit() do
    changeset %LoanLimit{}, %{amount: 227, status: "active", suspended_until: "00"}
  end
end

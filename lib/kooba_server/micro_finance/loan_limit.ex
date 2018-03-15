defmodule KoobaServer.MicroFinance.LoanLimit do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanLimit
  alias KoobaServer.Money

 @status_includes ~w(active suspended)

  schema "loan_limits" do
    field :amount, Money.Ecto
    field :status, :string
    field :suspended_until, :string
    field :amount_string, :string, virtual: true
    belongs_to(:user, KoobaServer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%LoanLimit{} = loan_limit, attrs) do
    loan_limit
    |> cast(attrs, [:amount_string, :status, :suspended_until])
    |> validate_required([:amount_string, :status, :suspended_until])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "is invalid price, formart: 00.00")
    |> validate_inclusion(:status, @status_includes)
    |> assoc_constraint(:user)
  end

  def build_initial_limit() do
    initial = %{amount_string: "227.00", status: "active", suspended_until: "00" }
    case changeset(%LoanLimit{}, initial) do
      %Ecto.Changeset{valid?: true, changes: %{amount_string: amt,status: status, suspended_until: susp }} ->
        #// TODO: currency will be from the user
        amount = amt <>" KSH"
        %LoanLimit{
          amount: Money.new(amount),
          status: status,
          suspended_until: susp
        }

      changeset ->
        changeset
    end
  end
end

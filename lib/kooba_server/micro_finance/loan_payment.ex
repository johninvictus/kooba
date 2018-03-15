defmodule KoobaServer.MicroFinance.LoanPayment do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanPayment


  schema "loan_payments" do
    field :amount, :string
    field :payment_schedue, :string
    field :status, :string
    field :type, :string
    field :notified_count, :integer

    belongs_to(:loan_taken, KoobaServer.MicroFinance.LoanTaken)

    timestamps()
  end

  @doc false
  def changeset(%LoanPayment{} = loan_payment, attrs) do
    loan_payment
    |> cast(attrs, [:payment_schedue, :type, :amount, :status])
    |> validate_required([:payment_schedue, :type, :amount, :status])
  end
end

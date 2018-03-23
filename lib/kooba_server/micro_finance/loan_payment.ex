defmodule KoobaServer.MicroFinance.LoanPayment do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto
  alias KoobaServer.MicroFinance.LoanPayment
  alias KoobaServer.Money
  alias KoobaServer.MicroFinance.LoanTaken

  @status_includes ~w(unpaid paid late)
  @type_includes ~w(normal penalty)

  schema "loan_payments" do
    field(:amount, Money.Ecto)
    field(:amount_string, :string, virtual: true)
    field(:payment_schedue, :string)
    field(:status, :string)
    field(:type, :string)
    field(:notified_count, :integer)

    belongs_to(:loan_taken, KoobaServer.MicroFinance.LoanTaken)

    timestamps()
  end

  @doc false
  def changeset(%LoanPayment{} = loan_payment, attrs) do
    loan_payment
    |> cast(attrs, [:payment_schedue, :type, :amount_string, :status, :notified_count])
    |> validate_required([:payment_schedue, :type, :amount_string, :status, :notified_count])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> validate_inclusion(:status, @status_includes)
    |> validate_inclusion(:type, @type_includes)
  end

  def build_changeset(%LoanTaken{} = loans_taken, %LoanPayment{} = loan_payment, attrs) do
    changeset = changeset(loan_payment, attrs)

    if changeset.valid? do
      data = changeset |> apply_changes()
      amount = Money.new("#{data.amount_string} " <> "KSH")
      # struct(LoanPayment, Map.put(data, :amount, amount))
      %LoanPayment{
        loan_taken: loans_taken,
        amount: amount,
        payment_schedue: data.payment_schedue,
        status: data.status,
        type: data.type,
        notified_count: data.notified_count
      }
    else
      changeset
    end
  end

  def generate_loan_payment(%LoanTaken{} = loans_taken, attrs) do
    # loans_taken
    # |> build_assoc(:loan_payments)
    # |> build_changeset(attrs)
    build_changeset(loans_taken, %LoanPayment{}, attrs)
  end
end
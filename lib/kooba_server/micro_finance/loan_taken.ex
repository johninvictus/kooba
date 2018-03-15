defmodule KoobaServer.MicroFinance.LoanTaken do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanTaken



  schema "loans_taken" do
    field :late_fee, :integer
    field :loan_amount, :integer
    field :loan_interest, :integer
    field :loan_total, :integer
    field :next_payment_id, :integer
    field :notified_count, :integer
    field :status, :string

    belongs_to(:user, KoobaServer.Accounts.User)
    belongs_to(:loan_setting, KoobaServer.MicroFinance.LoanSetting)
    has_many(:loan_payments, KoobaServer.MicroFinance.LoanPayment)

    timestamps()
  end

  @doc false
  def changeset(%LoanTaken{} = loan_taken, attrs) do
    loan_taken
    |> cast(attrs, [:status, :loan_amount, :loan_interest, :late_fee, :loan_total, :notified_count, :next_payment_id])
    |> validate_required([:status, :loan_amount, :loan_interest, :late_fee, :loan_total, :notified_count, :next_payment_id])
  end
end

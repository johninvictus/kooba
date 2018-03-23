defmodule KoobaServer.MicroFinance.LoanTaken do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanTaken
  alias KoobaServer.Money

  schema "loan_taken" do
    field(:late_fee, Money.Ecto)
    field(:loan_amount, Money.Ecto)
    field(:loan_interest, Money.Ecto)
    field(:loan_total, Money.Ecto)
    field(:next_payment_id, :integer)
    field(:notified_count, :integer)
    # close, active, pending
    field(:status, :string)

    belongs_to(:user, KoobaServer.Accounts.User)
    belongs_to(:loan_setting, KoobaServer.MicroFinance.LoanSetting)
    has_many(:loan_payments, KoobaServer.MicroFinance.LoanPayment)

    timestamps()
  end

  @doc false
  def changeset(%LoanTaken{} = loan_taken, attrs) do
    loan_taken
    |> cast(attrs, [
      :status,
      :loan_amount,
      :loan_interest,
      :late_fee,
      :loan_total,
      :notified_count,
      :next_payment_id
    ])
    |> validate_required([
      :status,
      :loan_amount,
      :loan_interest,
      :late_fee,
      :loan_total,
      :notified_count,
      :next_payment_id
    ])
  end
end

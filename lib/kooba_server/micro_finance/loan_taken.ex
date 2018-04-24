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

    field(:late_fee_string, :string, virtual: true)
    field(:loan_amount_string, :string, virtual: true)
    field(:loan_interest_string, :string, virtual: true)
    field(:loan_total_string, :string, virtual: true)

    field(:next_payment_id, :integer)
    field(:notified_count, :integer)
    # closed, active, pending, late
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
      :loan_amount_string,
      :loan_interest_string,
      :late_fee_string,
      :loan_total_string,
      :notified_count,
      :next_payment_id
    ])
    |> validate_required([
      :status,
      :loan_amount_string,
      :loan_interest_string,
      :late_fee_string,
      :loan_total_string,
      :notified_count,
      :next_payment_id
    ])
    |> validate_format(
      :loan_amount_string,
      ~r/\A\d+\.\d{2}\Z/,
      message: "money format is invalid"
    )
    |> validate_format(
      :loan_interest_string,
      ~r/\A\d+\.\d{2}\Z/,
      message: "money format is invalid"
    )
    |> validate_format(:late_fee_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> validate_format(:loan_total_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> put_late_fee()
    |> put_loan_amount()
    |> put_loan_interest()
    |> put_loan_total()
  end

  defp put_late_fee(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        put_change(changeset, :late_fee, create_money(data.late_fee_string))

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp put_loan_amount(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        put_change(changeset, :loan_amount, create_money(data.loan_amount_string))

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp put_loan_interest(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        put_change(changeset, :loan_interest, create_money(data.loan_interest_string))

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp put_loan_total(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        put_change(changeset, :loan_total, create_money(data.loan_total_string))

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp create_money(m_string) do
    Money.new("#{m_string} " <> "KSH")
  end
end

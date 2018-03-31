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
    field(:payment_remaining, Money.Ecto)

    field(:amount_string, :string, virtual: true)
    field(:payment_remaining_string, :string, virtual: true)

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
    |> cast(attrs, [
      :payment_schedue,
      :type,
      :amount_string,
      :status,
      :notified_count,
      :payment_remaining_string
    ])
    |> validate_required([
      :payment_schedue,
      :type,
      :amount_string,
      :status,
      :notified_count,
      :payment_remaining_string
    ])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> put_amount()
    |> validate_format(
      :payment_remaining_string,
      ~r/\A\d+\.\d{2}\Z/,
      message: "money format is invalid"
    )
    |> put_payment_remaining()
    |> validate_inclusion(:status, @status_includes)
    |> validate_inclusion(:type, @type_includes)
  end

  defp put_amount(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        amount = Money.new("#{data.amount_string} " <> "KSH")

        put_change(changeset, :amount, amount)

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp put_payment_remaining(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        payment_remaining = Money.new("#{data.payment_remaining_string} " <> "KSH")
        put_change(changeset, :payment_remaining, payment_remaining)

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  def generate_loan_payment(%LoanTaken{} = loans_taken, attrs) do
    loans_taken
    |> build_assoc(:loan_payments)
    |> changeset(attrs)
  end

  def generate_update_changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :payment_schedue,
      :type,
      :amount_string,
      :status,
      :notified_count,
      :payment_remaining_string,
      :id,
      :loan_taken_id
    ])
    |> validate_required([
      :payment_schedue,
      :type,
      :amount_string,
      :status,
      :notified_count,
      :payment_remaining_string,
      :id,
      :loan_taken_id
    ])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> put_amount()
    |> validate_format(
      :payment_remaining_string,
      ~r/\A\d+\.\d{2}\Z/,
      message: "money format is invalid"
    )
    |> put_payment_remaining()
    |> validate_inclusion(:status, @status_includes)
    |> validate_inclusion(:type, @type_includes)
  end
end

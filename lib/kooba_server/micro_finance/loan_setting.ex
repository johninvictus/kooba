defmodule KoobaServer.MicroFinance.LoanSetting do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanSetting
  alias KoobaServer.Money


  schema "loan_settings" do
    field :name, :string
    field :frequency, :integer
    field :interest, :integer
    field :late_interest, :integer
    field :term, :integer
    field :term_measure, :string
    field :min_amount, Money.Ecto

    field :min_amount_string, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%LoanSetting{} = loan_setting, attrs) do
    loan_setting
    |> cast(attrs, [:min_amount_string, :name, :term_measure, :frequency, :term, :interest, :late_interest])
    |> validate_required([:min_amount_string, :term_measure, :frequency, :term, :interest, :late_interest])
    |> validate_format(:min_amount_string, ~r/\A\d+\.\d{2}\Z/, message: "price format is invalid")
  end

  def build(%LoanSetting{} = loan_setting, attrs) do
    changeset = changeset(loan_setting, attrs)
    if changeset.valid? do
      data = apply_changes(changeset) |> Map.from_struct()
      amount = Money.new("#{data.min_amount_string} " <> "KSH")
      struct(LoanSetting, Map.put(data, :min_amount, amount))
    else
      changeset
    end
  end
end

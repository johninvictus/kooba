defmodule KoobaServer.MicroFinance.LoanSetting do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanSetting


  schema "loan_settings" do
    field :frequency, :integer
    field :interest, :integer
    field :late_interest, :integer
    field :term, :integer
    field :term_measure, :string

    timestamps()
  end

  @doc false
  def changeset(%LoanSetting{} = loan_setting, attrs) do
    loan_setting
    |> cast(attrs, [:term_measure, :frequency, :term, :interest, :late_interest])
    |> validate_required([:term_measure, :frequency, :term, :interest, :late_interest])
  end
end

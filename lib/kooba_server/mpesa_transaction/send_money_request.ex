defmodule KoobaServer.MpesaTransaction.SendMoneyRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MpesaTransaction.SendMoneyRequest

  @status_includes ~w(success failed pending)

  schema "send_money_request" do
    field(:convertion_id, :string)
    field(:originator_conversation_id, :string)
    field(:status, :string)
    field(:receipt, :string)

    belongs_to(:loan_taken, KoobaServer.MicroFinance.LoanTaken)

    timestamps()
  end

  @doc false
  def changeset(%SendMoneyRequest{} = send_money_request, attrs) do
    send_money_request
    |> cast(attrs, [:convertion_id, :originator_conversation_id, :status, :receipt])
    |> validate_required([:convertion_id, :originator_conversation_id, :status])
    |> validate_inclusion(:status, @status_includes)
  end
end

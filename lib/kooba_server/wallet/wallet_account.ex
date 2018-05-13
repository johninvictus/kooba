defmodule KoobaServer.Wallet.WalletAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.Wallet.WalletAccount
  alias KoobaServer.Money

  schema "wallet_accounts" do
    field(:amount, Money.Ecto)
    field(:amount_string, :string, virtual: true)
    field(:phone, :string)

    timestamps()
  end

  @doc false
  def changeset(%WalletAccount{} = wallet_account, attrs) do
    wallet_account
    |> cast(attrs, [:phone, :amount_string])
    |> validate_required([:phone, :amount_string])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> put_amount()
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
end

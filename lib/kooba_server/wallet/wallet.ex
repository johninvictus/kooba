defmodule KoobaServer.Wallet do
  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias KoobaServer.Repo
  alias KoobaServer.Money

  alias KoobaServer.Wallet.WalletAccount

  @doc """
  Create wallet or update the balance of a particular number(user)
  """
  def addToWallet(attrs \\ %{}) do
    changeset = WalletAccount.changeset(%WalletAccount{}, attrs)

    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()

        result =
          case(Repo.get_by(WalletAccount, phone: data.phone)) do
            nil ->
              %WalletAccount{}

            wallet ->
              # post exists
              wallet
          end
          |> generate_changeset(attrs, data.amount)
          |> Repo.insert_or_update()

        case result do
          {:ok, model} ->
            {:ok, model}

          {:error, changeset} ->
            changeset
        end

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  defp generate_changeset(%WalletAccount{} = wallet_account, attrs, add_amount) do
    case wallet_account do
      %WalletAccount{amount: nil} ->
        WalletAccount.changeset(wallet_account, attrs)

      %WalletAccount{amount: amount} ->
        %KoobaServer.Money{cents: cents} = amount
        %KoobaServer.Money{cents: add_cents} = add_amount

        total_amount = (cents + add_cents) / 100

        WalletAccount.changeset(wallet_account, %{
          amount_string: "#{total_amount}0",
          phone: attrs["phone"]
        })
    end
  end

  @doc """
  Returns the balance
  """
  def get_walllet_balance(phone) do
    case Repo.get_by(WalletAccount, phone: phone) do
      nil ->
        %Money{cents: 0, currency: "KSH"}

      model when is_map(model) ->
        model.amount

      _ ->
        :error
    end
  end

  @doc """
  Returns the list of wallet_accounts.

  ## Examples

      iex> list_wallet_accounts()
      [%WalletAccount{}, ...]

  """
  def list_wallet_accounts do
    Repo.all(WalletAccount)
  end

  @doc """
  Gets a single wallet_account.

  Raises `Ecto.NoResultsError` if the Wallet account does not exist.

  ## Examples

      iex> get_wallet_account!(123)
      %WalletAccount{}

      iex> get_wallet_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet_account!(id), do: Repo.get!(WalletAccount, id)

  @doc """
  Creates a wallet_account.

  ## Examples

      iex> create_wallet_account(%{field: value})
      {:ok, %WalletAccount{}}

      iex> create_wallet_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet_account(attrs \\ %{}) do
    %WalletAccount{}
    |> WalletAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet_account.

  ## Examples

      iex> update_wallet_account(wallet_account, %{field: new_value})
      {:ok, %WalletAccount{}}

      iex> update_wallet_account(wallet_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_account(%WalletAccount{} = wallet_account, attrs) do
    wallet_account
    |> WalletAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WalletAccount.

  ## Examples

      iex> delete_wallet_account(wallet_account)
      {:ok, %WalletAccount{}}

      iex> delete_wallet_account(wallet_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet_account(%WalletAccount{} = wallet_account) do
    Repo.delete(wallet_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet_account changes.

  ## Examples

      iex> change_wallet_account(wallet_account)
      %Ecto.Changeset{source: %WalletAccount{}}

  """
  def change_wallet_account(%WalletAccount{} = wallet_account) do
    WalletAccount.changeset(wallet_account, %{})
  end
end

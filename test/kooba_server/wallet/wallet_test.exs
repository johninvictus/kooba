defmodule KoobaServer.WalletTest do
  use KoobaServer.DataCase

  alias KoobaServer.Wallet

  describe "wallet_accounts" do
    alias KoobaServer.Wallet.WalletAccount

    @valid_attrs %{balance: "some balance", phone: "some phone"}
    @update_attrs %{balance: "some updated balance", phone: "some updated phone"}
    @invalid_attrs %{balance: nil, phone: nil}

    def wallet_account_fixture(attrs \\ %{}) do
      {:ok, wallet_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Wallet.create_wallet_account()

      wallet_account
    end

    test "list_wallet_accounts/0 returns all wallet_accounts" do
      wallet_account = wallet_account_fixture()
      assert Wallet.list_wallet_accounts() == [wallet_account]
    end

    test "get_wallet_account!/1 returns the wallet_account with given id" do
      wallet_account = wallet_account_fixture()
      assert Wallet.get_wallet_account!(wallet_account.id) == wallet_account
    end

    test "create_wallet_account/1 with valid data creates a wallet_account" do
      assert {:ok, %WalletAccount{} = wallet_account} = Wallet.create_wallet_account(@valid_attrs)
      assert wallet_account.balance == "some balance"
      assert wallet_account.phone == "some phone"
    end

    test "create_wallet_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_wallet_account(@invalid_attrs)
    end

    test "update_wallet_account/2 with valid data updates the wallet_account" do
      wallet_account = wallet_account_fixture()
      assert {:ok, wallet_account} = Wallet.update_wallet_account(wallet_account, @update_attrs)
      assert %WalletAccount{} = wallet_account
      assert wallet_account.balance == "some updated balance"
      assert wallet_account.phone == "some updated phone"
    end

    test "update_wallet_account/2 with invalid data returns error changeset" do
      wallet_account = wallet_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallet.update_wallet_account(wallet_account, @invalid_attrs)
      assert wallet_account == Wallet.get_wallet_account!(wallet_account.id)
    end

    test "delete_wallet_account/1 deletes the wallet_account" do
      wallet_account = wallet_account_fixture()
      assert {:ok, %WalletAccount{}} = Wallet.delete_wallet_account(wallet_account)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_wallet_account!(wallet_account.id) end
    end

    test "change_wallet_account/1 returns a wallet_account changeset" do
      wallet_account = wallet_account_fixture()
      assert %Ecto.Changeset{} = Wallet.change_wallet_account(wallet_account)
    end
  end
end

defmodule KoobaServer.AccountsTest do
  use KoobaServer.DataCase

  alias KoobaServer.Accounts

  describe "users" do
    alias KoobaServer.Accounts.User

    @valid_attrs %{access_token: "some access_token", phone: 42}
    @update_attrs %{access_token: "some updated access_token", phone: 43}
    @invalid_attrs %{access_token: nil, phone: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.access_token == "some access_token"
      assert user.phone == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.access_token == "some updated access_token"
      assert user.phone == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_details" do
    alias KoobaServer.Accounts.UserDetail

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_detail_fixture(attrs \\ %{}) do
      {:ok, user_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_detail()

      user_detail
    end

    test "list_user_details/0 returns all user_details" do
      user_detail = user_detail_fixture()
      assert Accounts.list_user_details() == [user_detail]
    end

    test "get_user_detail!/1 returns the user_detail with given id" do
      user_detail = user_detail_fixture()
      assert Accounts.get_user_detail!(user_detail.id) == user_detail
    end

    test "create_user_detail/1 with valid data creates a user_detail" do
      assert {:ok, %UserDetail{} = user_detail} = Accounts.create_user_detail(@valid_attrs)
    end

    test "create_user_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_detail(@invalid_attrs)
    end

    test "update_user_detail/2 with valid data updates the user_detail" do
      user_detail = user_detail_fixture()
      assert {:ok, user_detail} = Accounts.update_user_detail(user_detail, @update_attrs)
      assert %UserDetail{} = user_detail
    end

    test "update_user_detail/2 with invalid data returns error changeset" do
      user_detail = user_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_detail(user_detail, @invalid_attrs)
      assert user_detail == Accounts.get_user_detail!(user_detail.id)
    end

    test "delete_user_detail/1 deletes the user_detail" do
      user_detail = user_detail_fixture()
      assert {:ok, %UserDetail{}} = Accounts.delete_user_detail(user_detail)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_detail!(user_detail.id) end
    end

    test "change_user_detail/1 returns a user_detail changeset" do
      user_detail = user_detail_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_detail(user_detail)
    end
  end
end

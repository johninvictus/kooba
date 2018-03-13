defmodule KoobaServer.MicroFinanceTest do
  use KoobaServer.DataCase

  alias KoobaServer.MicroFinance

  describe "loan_settings" do
    alias KoobaServer.MicroFinance.LoanSetting

    @valid_attrs %{frequency: 42, interest: 42, late_interest: 42, term: 42, term_measure: "some term_measure"}
    @update_attrs %{frequency: 43, interest: 43, late_interest: 43, term: 43, term_measure: "some updated term_measure"}
    @invalid_attrs %{frequency: nil, interest: nil, late_interest: nil, term: nil, term_measure: nil}

    def loan_setting_fixture(attrs \\ %{}) do
      {:ok, loan_setting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MicroFinance.create_loan_setting()

      loan_setting
    end

    test "list_loan_settings/0 returns all loan_settings" do
      loan_setting = loan_setting_fixture()
      assert MicroFinance.list_loan_settings() == [loan_setting]
    end

    test "get_loan_setting!/1 returns the loan_setting with given id" do
      loan_setting = loan_setting_fixture()
      assert MicroFinance.get_loan_setting!(loan_setting.id) == loan_setting
    end

    test "create_loan_setting/1 with valid data creates a loan_setting" do
      assert {:ok, %LoanSetting{} = loan_setting} = MicroFinance.create_loan_setting(@valid_attrs)
      assert loan_setting.frequency == 42
      assert loan_setting.interest == 42
      assert loan_setting.late_interest == 42
      assert loan_setting.term == 42
      assert loan_setting.term_measure == "some term_measure"
    end

    test "create_loan_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MicroFinance.create_loan_setting(@invalid_attrs)
    end

    test "update_loan_setting/2 with valid data updates the loan_setting" do
      loan_setting = loan_setting_fixture()
      assert {:ok, loan_setting} = MicroFinance.update_loan_setting(loan_setting, @update_attrs)
      assert %LoanSetting{} = loan_setting
      assert loan_setting.frequency == 43
      assert loan_setting.interest == 43
      assert loan_setting.late_interest == 43
      assert loan_setting.term == 43
      assert loan_setting.term_measure == "some updated term_measure"
    end

    test "update_loan_setting/2 with invalid data returns error changeset" do
      loan_setting = loan_setting_fixture()
      assert {:error, %Ecto.Changeset{}} = MicroFinance.update_loan_setting(loan_setting, @invalid_attrs)
      assert loan_setting == MicroFinance.get_loan_setting!(loan_setting.id)
    end

    test "delete_loan_setting/1 deletes the loan_setting" do
      loan_setting = loan_setting_fixture()
      assert {:ok, %LoanSetting{}} = MicroFinance.delete_loan_setting(loan_setting)
      assert_raise Ecto.NoResultsError, fn -> MicroFinance.get_loan_setting!(loan_setting.id) end
    end

    test "change_loan_setting/1 returns a loan_setting changeset" do
      loan_setting = loan_setting_fixture()
      assert %Ecto.Changeset{} = MicroFinance.change_loan_setting(loan_setting)
    end
  end

  describe "loan_limits" do
    alias KoobaServer.MicroFinance.LoanLimit

    @valid_attrs %{amount: 42, status: "some status", suspended_until: "some suspended_until"}
    @update_attrs %{amount: 43, status: "some updated status", suspended_until: "some updated suspended_until"}
    @invalid_attrs %{amount: nil, status: nil, suspended_until: nil}

    def loan_limit_fixture(attrs \\ %{}) do
      {:ok, loan_limit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MicroFinance.create_loan_limit()

      loan_limit
    end

    test "list_loan_limits/0 returns all loan_limits" do
      loan_limit = loan_limit_fixture()
      assert MicroFinance.list_loan_limits() == [loan_limit]
    end

    test "get_loan_limit!/1 returns the loan_limit with given id" do
      loan_limit = loan_limit_fixture()
      assert MicroFinance.get_loan_limit!(loan_limit.id) == loan_limit
    end

    test "create_loan_limit/1 with valid data creates a loan_limit" do
      assert {:ok, %LoanLimit{} = loan_limit} = MicroFinance.create_loan_limit(@valid_attrs)
      assert loan_limit.amount == 42
      assert loan_limit.status == "some status"
      assert loan_limit.suspended_until == "some suspended_until"
    end

    test "create_loan_limit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MicroFinance.create_loan_limit(@invalid_attrs)
    end

    test "update_loan_limit/2 with valid data updates the loan_limit" do
      loan_limit = loan_limit_fixture()
      assert {:ok, loan_limit} = MicroFinance.update_loan_limit(loan_limit, @update_attrs)
      assert %LoanLimit{} = loan_limit
      assert loan_limit.amount == 43
      assert loan_limit.status == "some updated status"
      assert loan_limit.suspended_until == "some updated suspended_until"
    end

    test "update_loan_limit/2 with invalid data returns error changeset" do
      loan_limit = loan_limit_fixture()
      assert {:error, %Ecto.Changeset{}} = MicroFinance.update_loan_limit(loan_limit, @invalid_attrs)
      assert loan_limit == MicroFinance.get_loan_limit!(loan_limit.id)
    end

    test "delete_loan_limit/1 deletes the loan_limit" do
      loan_limit = loan_limit_fixture()
      assert {:ok, %LoanLimit{}} = MicroFinance.delete_loan_limit(loan_limit)
      assert_raise Ecto.NoResultsError, fn -> MicroFinance.get_loan_limit!(loan_limit.id) end
    end

    test "change_loan_limit/1 returns a loan_limit changeset" do
      loan_limit = loan_limit_fixture()
      assert %Ecto.Changeset{} = MicroFinance.change_loan_limit(loan_limit)
    end
  end
end

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

  describe "loans_taken" do
    alias KoobaServer.MicroFinance.LoanTaken

    @valid_attrs %{late_fee: 42, loan_amount: 42, loan_interest: 42, loan_total: 42, next_payment_id: 42, notified_count: 42, status: "some status"}
    @update_attrs %{late_fee: 43, loan_amount: 43, loan_interest: 43, loan_total: 43, next_payment_id: 43, notified_count: 43, status: "some updated status"}
    @invalid_attrs %{late_fee: nil, loan_amount: nil, loan_interest: nil, loan_total: nil, next_payment_id: nil, notified_count: nil, status: nil}

    def loan_taken_fixture(attrs \\ %{}) do
      {:ok, loan_taken} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MicroFinance.create_loan_taken()

      loan_taken
    end

    test "list_loans_taken/0 returns all loans_taken" do
      loan_taken = loan_taken_fixture()
      assert MicroFinance.list_loans_taken() == [loan_taken]
    end

    test "get_loan_taken!/1 returns the loan_taken with given id" do
      loan_taken = loan_taken_fixture()
      assert MicroFinance.get_loan_taken!(loan_taken.id) == loan_taken
    end

    test "create_loan_taken/1 with valid data creates a loan_taken" do
      assert {:ok, %LoanTaken{} = loan_taken} = MicroFinance.create_loan_taken(@valid_attrs)
      assert loan_taken.late_fee == 42
      assert loan_taken.loan_amount == 42
      assert loan_taken.loan_interest == 42
      assert loan_taken.loan_total == 42
      assert loan_taken.next_payment_id == 42
      assert loan_taken.notified_count == 42
      assert loan_taken.status == "some status"
    end

    test "create_loan_taken/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MicroFinance.create_loan_taken(@invalid_attrs)
    end

    test "update_loan_taken/2 with valid data updates the loan_taken" do
      loan_taken = loan_taken_fixture()
      assert {:ok, loan_taken} = MicroFinance.update_loan_taken(loan_taken, @update_attrs)
      assert %LoanTaken{} = loan_taken
      assert loan_taken.late_fee == 43
      assert loan_taken.loan_amount == 43
      assert loan_taken.loan_interest == 43
      assert loan_taken.loan_total == 43
      assert loan_taken.next_payment_id == 43
      assert loan_taken.notified_count == 43
      assert loan_taken.status == "some updated status"
    end

    test "update_loan_taken/2 with invalid data returns error changeset" do
      loan_taken = loan_taken_fixture()
      assert {:error, %Ecto.Changeset{}} = MicroFinance.update_loan_taken(loan_taken, @invalid_attrs)
      assert loan_taken == MicroFinance.get_loan_taken!(loan_taken.id)
    end

    test "delete_loan_taken/1 deletes the loan_taken" do
      loan_taken = loan_taken_fixture()
      assert {:ok, %LoanTaken{}} = MicroFinance.delete_loan_taken(loan_taken)
      assert_raise Ecto.NoResultsError, fn -> MicroFinance.get_loan_taken!(loan_taken.id) end
    end

    test "change_loan_taken/1 returns a loan_taken changeset" do
      loan_taken = loan_taken_fixture()
      assert %Ecto.Changeset{} = MicroFinance.change_loan_taken(loan_taken)
    end
  end

  describe "loan_payments" do
    alias KoobaServer.MicroFinance.LoanPayment

    @valid_attrs %{amount: "some amount", payment_schedue: "some payment_schedue", status: "some status", type: "some type"}
    @update_attrs %{amount: "some updated amount", payment_schedue: "some updated payment_schedue", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{amount: nil, payment_schedue: nil, status: nil, type: nil}

    def loan_payment_fixture(attrs \\ %{}) do
      {:ok, loan_payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MicroFinance.create_loan_payment()

      loan_payment
    end

    test "list_loan_payments/0 returns all loan_payments" do
      loan_payment = loan_payment_fixture()
      assert MicroFinance.list_loan_payments() == [loan_payment]
    end

    test "get_loan_payment!/1 returns the loan_payment with given id" do
      loan_payment = loan_payment_fixture()
      assert MicroFinance.get_loan_payment!(loan_payment.id) == loan_payment
    end

    test "create_loan_payment/1 with valid data creates a loan_payment" do
      assert {:ok, %LoanPayment{} = loan_payment} = MicroFinance.create_loan_payment(@valid_attrs)
      assert loan_payment.amount == "some amount"
      assert loan_payment.payment_schedue == "some payment_schedue"
      assert loan_payment.status == "some status"
      assert loan_payment.type == "some type"
    end

    test "create_loan_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MicroFinance.create_loan_payment(@invalid_attrs)
    end

    test "update_loan_payment/2 with valid data updates the loan_payment" do
      loan_payment = loan_payment_fixture()
      assert {:ok, loan_payment} = MicroFinance.update_loan_payment(loan_payment, @update_attrs)
      assert %LoanPayment{} = loan_payment
      assert loan_payment.amount == "some updated amount"
      assert loan_payment.payment_schedue == "some updated payment_schedue"
      assert loan_payment.status == "some updated status"
      assert loan_payment.type == "some updated type"
    end

    test "update_loan_payment/2 with invalid data returns error changeset" do
      loan_payment = loan_payment_fixture()
      assert {:error, %Ecto.Changeset{}} = MicroFinance.update_loan_payment(loan_payment, @invalid_attrs)
      assert loan_payment == MicroFinance.get_loan_payment!(loan_payment.id)
    end

    test "delete_loan_payment/1 deletes the loan_payment" do
      loan_payment = loan_payment_fixture()
      assert {:ok, %LoanPayment{}} = MicroFinance.delete_loan_payment(loan_payment)
      assert_raise Ecto.NoResultsError, fn -> MicroFinance.get_loan_payment!(loan_payment.id) end
    end

    test "change_loan_payment/1 returns a loan_payment changeset" do
      loan_payment = loan_payment_fixture()
      assert %Ecto.Changeset{} = MicroFinance.change_loan_payment(loan_payment)
    end
  end
end

defmodule KoobaServer.MicroFinance do
  @moduledoc """
  The MicroFinance context.
  """

  import Ecto.Query, warn: false
  alias KoobaServer.Repo

  alias KoobaServer.MicroFinance.LoanSetting
  alias KoobaServer.Accounts.User
  alias KoobaServer.Money

  @doc """
  Returns the list of loan_settings.

  ## Examples

      iex> list_loan_settings()
      [%LoanSetting{}, ...]

  """
  def list_loan_settings do
    Repo.all(LoanSetting)
  end

  @doc """
  Gets a single loan_setting.

  Raises `Ecto.NoResultsError` if the Loan setting does not exist.

  ## Examples

      iex> get_loan_setting!(123)
      %LoanSetting{}

      iex> get_loan_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_setting!(id), do: Repo.get!(LoanSetting, id)

  @doc """
  Creates a loan_setting.

  ## Examples

      iex> create_loan_setting(%{field: value})
      {:ok, %LoanSetting{}}

      iex> create_loan_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_setting(attrs \\ %{}) do
    %LoanSetting{}
    |> LoanSetting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_setting.

  ## Examples

      iex> update_loan_setting(loan_setting, %{field: new_value})
      {:ok, %LoanSetting{}}

      iex> update_loan_setting(loan_setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_setting(%LoanSetting{} = loan_setting, attrs) do
    loan_setting
    |> LoanSetting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LoanSetting.

  ## Examples

      iex> delete_loan_setting(loan_setting)
      {:ok, %LoanSetting{}}

      iex> delete_loan_setting(loan_setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_setting(%LoanSetting{} = loan_setting) do
    Repo.delete(loan_setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_setting changes.

  ## Examples

      iex> change_loan_setting(loan_setting)
      %Ecto.Changeset{source: %LoanSetting{}}

  """
  def change_loan_setting(%LoanSetting{} = loan_setting) do
    LoanSetting.changeset(loan_setting, %{})
  end

  alias KoobaServer.MicroFinance.LoanLimit

  @doc """
  Returns the list of loan_limits.

  ## Examples

      iex> list_loan_limits()
      [%LoanLimit{}, ...]

  """
  def list_loan_limits do
    Repo.all(LoanLimit)
  end

  @doc """
  Gets a single loan_limit.

  Raises `Ecto.NoResultsError` if the Loan limit does not exist.

  ## Examples

      iex> get_loan_limit!(123)
      %LoanLimit{}

      iex> get_loan_limit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_limit!(id), do: Repo.get!(LoanLimit, id)

  @doc """
  Creates a loan_limit.

  ## Examples

      iex> create_loan_limit(%{field: value})
      {:ok, %LoanLimit{}}

      iex> create_loan_limit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_limit(attrs \\ %{}) do
    %LoanLimit{}
    |> LoanLimit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_limit.

  ## Examples

      iex> update_loan_limit(loan_limit, %{field: new_value})
      {:ok, %LoanLimit{}}

      iex> update_loan_limit(loan_limit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_limit(%LoanLimit{} = loan_limit, attrs) do
    loan_limit
    |> LoanLimit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LoanLimit.

  ## Examples

      iex> delete_loan_limit(loan_limit)
      {:ok, %LoanLimit{}}

      iex> delete_loan_limit(loan_limit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_limit(%LoanLimit{} = loan_limit) do
    Repo.delete(loan_limit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_limit changes.

  ## Examples

      iex> change_loan_limit(loan_limit)
      %Ecto.Changeset{source: %LoanLimit{}}

  """
  def change_loan_limit(%LoanLimit{} = loan_limit) do
    LoanLimit.changeset(loan_limit, %{})
  end

  alias KoobaServer.MicroFinance.LoanTaken

  @doc """
  Returns the list of loans_taken.

  ## Examples

      iex> list_loans_taken()
      [%LoanTaken{}, ...]

  """
  def list_loans_taken do
    Repo.all(LoanTaken)
  end

  @doc """
  Gets a single loan_taken.

  Raises `Ecto.NoResultsError` if the Loan taken does not exist.

  ## Examples

      iex> get_loan_taken!(123)
      %LoanTaken{}

      iex> get_loan_taken!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_taken!(id), do: Repo.get!(LoanTaken, id)

  def user_has_loan?(user_id) do
    query =
      from(
        c in LoanTaken,
        where: (c.user_id == ^user_id and c.status == "active") or c.status == "pending"
      )

    Repo.one(query)
    |> case do
      nil ->
        false

      _ ->
        true
    end
  end

  def get_user_open_loan(%User{} = user) do
    query =
      from(
        c in LoanTaken,
        where: (c.user_id == ^user.id and c.status == "active") or c.status == "pending"
      )

    Repo.one(query)
  end

  @doc """
  Creates a loan_taken.

  ## Examples

      iex> create_loan_taken(%{field: value})
      {:ok, %LoanTaken{}}

      iex> create_loan_taken(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_taken(attrs \\ %{}) do
    %LoanTaken{}
    |> LoanTaken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_taken.

  ## Examples

      iex> update_loan_taken(loan_taken, %{field: new_value})
      {:ok, %LoanTaken{}}

      iex> update_loan_taken(loan_taken, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_taken(%LoanTaken{} = loan_taken, attrs) do
    loan_taken
    |> LoanTaken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LoanTaken.

  ## Examples

      iex> delete_loan_taken(loan_taken)
      {:ok, %LoanTaken{}}

      iex> delete_loan_taken(loan_taken)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_taken(%LoanTaken{} = loan_taken) do
    Repo.delete(loan_taken)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_taken changes.

  ## Examples

      iex> change_loan_taken(loan_taken)
      %Ecto.Changeset{source: %LoanTaken{}}

  """
  def change_loan_taken(%LoanTaken{} = loan_taken) do
    LoanTaken.changeset(loan_taken, %{})
  end

  alias KoobaServer.MicroFinance.LoanPayment

  @doc """
  Returns the list of loan_payments.

  ## Examples

      iex> list_loan_payments()
      [%LoanPayment{}, ...]

  """
  def list_loan_payments do
    Repo.all(LoanPayment)
  end

  @doc """
  Gets a single loan_payment.

  Raises `Ecto.NoResultsError` if the Loan payment does not exist.

  ## Examples

      iex> get_loan_payment!(123)
      %LoanPayment{}

      iex> get_loan_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_payment!(id), do: Repo.get!(LoanPayment, id)

  @doc """
  Creates a loan_payment.

  ## Examples

      iex> create_loan_payment(%{field: value})
      {:ok, %LoanPayment{}}

      iex> create_loan_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_payment(attrs \\ %{}) do
    %LoanPayment{}
    |> LoanPayment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_payment.

  ## Examples

      iex> update_loan_payment(loan_payment, %{field: new_value})
      {:ok, %LoanPayment{}}

      iex> update_loan_payment(loan_payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_payment(%LoanPayment{} = loan_payment, attrs) do
    loan_payment
    |> LoanPayment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LoanPayment.

  ## Examples

      iex> delete_loan_payment(loan_payment)
      {:ok, %LoanPayment{}}

      iex> delete_loan_payment(loan_payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_payment(%LoanPayment{} = loan_payment) do
    Repo.delete(loan_payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_payment changes.

  ## Examples

      iex> change_loan_payment(loan_payment)
      %Ecto.Changeset{source: %LoanPayment{}}

  """
  def change_loan_payment(%LoanPayment{} = loan_payment) do
    LoanPayment.changeset(loan_payment, %{})
  end

  @doc """
  List loans payments to pay arranged in asc order
  Loan payments not yet payed
  """
  def get_loan_payments(user) do
    open_loan = user |> get_user_open_loan()

    q =
      from(
        c in LoanPayment,
        where: (c.loan_taken_id == ^open_loan.id and c.status == "unpaid") or c.status == "late"
      )

    Repo.all(q)
  end

  def get_open_loan(loan_taken_id) do
    q = from(c in LoanTaken, where: c.id == ^loan_taken_id and c.status == "active")
    Repo.one(q)
  end

  def close_loan(loan_taken_id) do
    case get_open_loan(loan_taken_id) do
      nil ->
        {:error, :already_closed}

      loan_open when is_map(loan_open) ->
        if all_payments_payed?(loan_open.id) do
          update_loan_taken(loan_open, %{
            status: "closed",
            loan_amount_string: Money.no_currency_to_string(loan_open.loan_amount),
            loan_interest_string: Money.no_currency_to_string(loan_open.loan_interest),
            late_fee_string: Money.no_currency_to_string(loan_open.late_fee),
            loan_total_string: Money.no_currency_to_string(loan_open.loan_total)
          })
        else
          {:ok, loan_open}
        end
    end
  end

  def all_payments_payed?(loan_taken_id) do
    q =
      from(
        c in LoanPayment,
        where: (c.loan_taken_id == ^loan_taken_id and c.status == "unpaid") or c.status == "late"
      )

    case Repo.all(q) do
      [] ->
        true

      _ ->
        false
    end
  end
end

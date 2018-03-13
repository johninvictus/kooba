defmodule KoobaServer.MicroFinance do
  @moduledoc """
  The MicroFinance context.
  """

  import Ecto.Query, warn: false
  alias KoobaServer.Repo

  alias KoobaServer.MicroFinance.LoanSetting

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
end

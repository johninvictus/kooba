defmodule KoobaServer.MpesaTransaction do
  @moduledoc """
  The MpesaTransaction context.
  """

  import Ecto.Query, warn: false
  alias KoobaServer.Repo

  alias KoobaServer.MpesaTransaction.SendMoneyRequest

  @doc """
  Returns the list of send_request.

  ## Examples

      iex> list_send_request()
      [%{}, ...]

  """
  def list_send_request do
    Repo.all(SendMoneyRequest)
  end

  @doc """
  Gets a single send_request.

  Raises `Ecto.NoResultsError` if the Send request does not exist.

  ## Examples

      iex> get_send_request!(123)
      %SendMoneyRequest{}

      iex> get_send_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_send_request!(id), do: Repo.get!(SendMoneyRequest, id)

  @doc """
  Creates a send_request.

  ## Examples

      iex> create_send_request(%{field: value})
      {:ok, %SendMoneyRequest{}}

      iex> create_send_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_send_request(loan_taken, attrs \\ %{}) do
    loan_taken
    |> Ecto.build_assoc(:send_money_request)
    |> SendMoneyRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a send_request.

  ## Examples

      iex> update_send_request(send_request, %{field: new_value})
      {:ok, %SendMoneyRequest{}}

      iex> update_send_request(send_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_send_request(%SendMoneyRequest{} = send_request, attrs) do
    send_request
    |> SendMoneyRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SendMoneyRequest.

  ## Examples

      iex> delete_send_request(send_request)
      {:ok, %SendMoneyRequest{}}

      iex> delete_send_request(send_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_send_request(%SendMoneyRequest{} = send_request) do
    Repo.delete(send_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking send_request changes.

  ## Examples

      iex> change_send_request(send_request)
      %Ecto.Changeset{source: %SendMoneyRequest{}}

  """
  def change_send_request(%SendMoneyRequest{} = send_request) do
    SendMoneyRequest.changeset(send_request, %{})
  end
end

defmodule KoobaServer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias KoobaServer.Repo

  alias KoobaServer.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_user_by_phone(phone) do
    Repo.get_by(User, phone: phone)
  end

  alias KoobaServer.Accounts.UserDetail

  @doc """
  Returns the list of user_details.

  ## Examples

      iex> list_user_details()
      [%UserDetail{}, ...]

  """
  def list_user_details do
    Repo.all(UserDetail)
  end

  @doc """
  Gets a single user_detail.

  Raises `Ecto.NoResultsError` if the User detail does not exist.

  ## Examples

      iex> get_user_detail!(123)
      %UserDetail{}

      iex> get_user_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_detail(user) do
    user
    |> Ecto.assoc(:user_details)
    |> Repo.one()
  end

  @doc """
  Creates a user_detail.

  ## Examples

      iex> create_user_detail(%{field: value})
      {:ok, %UserDetail{}}

      iex> create_user_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_detail(%User{} = user, attrs \\ %{}) do
    # create just one entry
    case get_user_detail(user) do
      nil ->
        # can return either changeset or true
        user
        |> Ecto.build_assoc(:user_details)
        |> UserDetail.changeset(attrs)
        |> Repo.insert()

      details when is_map(details) ->
        # update data maybe instead returning the old data
        # may return {:ok, updated_detail} or {:ok, changeset}
        update_user_detail(details, attrs)
    end
  end

  @doc """
  Updates a user_detail.

  ## Examples

      iex> update_user_detail(user_detail, %{field: new_value})
      {:ok, %UserDetail{}}

      iex> update_user_detail(user_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_detail(%UserDetail{} = user_detail, attrs) do
    user_detail
    |> UserDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserDetail.

  ## Examples

      iex> delete_user_detail(user_detail)
      {:ok, %UserDetail{}}

      iex> delete_user_detail(user_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_detail(%UserDetail{} = user_detail) do
    Repo.delete(user_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_detail changes.

  ## Examples

      iex> change_user_detail(user_detail)
      %Ecto.Changeset{source: %UserDetail{}}

  """
  def change_user_detail(%UserDetail{} = user_detail) do
    UserDetail.changeset(user_detail, %{})
  end
end

defmodule KoobaServer.Notify do
  @moduledoc """
  The Notify context.
  """

  import Ecto.Query, warn: false
  alias KoobaServer.Repo

  alias KoobaServer.Notify.Notification
  alias KoobaServer.Accounts.User

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications()
      [%Notification{}, ...]

  """
  def list_notifications(user_id) do
    query = from(n in Notification, where: n.user_id == ^user_id, order_by: n.inserted_at)
    Repo.all(query)
  end

  def pagenated_notifications(params, user_id) do
    from(n in Notification, where: n.user_id == ^user_id, order_by: n.inserted_at)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(123)
      %Notification{}

      iex> get_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(id), do: Repo.get!(Notification, id)

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(%{field: value})
      {:ok, %Notification{}}

      iex> create_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:notifications)
    |> Notification.changeset(attrs)
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Notification.

  ## Examples

      iex> delete_notification(notification)
      {:ok, %Notification{}}

      iex> delete_notification(notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(notification)
      %Ecto.Changeset{source: %Notification{}}

  """
  def change_notification(%Notification{} = notification) do
    Notification.changeset(notification, %{})
  end
end

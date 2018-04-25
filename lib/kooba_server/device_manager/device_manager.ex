defmodule KoobaServer.DeviceManager do
  @moduledoc """
  The DeviceManager context.
  """

  use Ecto.Schema

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias KoobaServer.Repo
  alias KoobaServer.DeviceManager.Device
  alias KoobaServer.Accounts.User

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end

  @doc """
  Return devices that belongs to the user

  return null or a new device
  """
  def get_user_device(%User{} = user) do
    pre_user = user |> Repo.preload(:device)
    pre_user.device
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  @doc """
  Provide the device type, android or iphone and then update
  """
  def add_update_device(%User{} = user, attr) do
    changeset = Device.changeset(%Device{}, attr)

    case changeset do
      %Ecto.Changeset{valid?: true} ->
        query =
          from(
            c in Device,
            where: (c.user_id == ^user.id and c.name == "android") or c.name == "iphone"
          )

        device = Repo.one(query)

        cond do
          device != nil ->
            # update the existing record
            update_device(device, attr)

          true ->
            create_device(user, attr)
        end

      %Ecto.Changeset{valid?: false} ->
        {:error, changeset}
    end
  end

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:device)
    |> Device.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{source: %Device{}}

  """
  def change_device(%Device{} = device) do
    Device.changeset(device, %{})
  end
end

defmodule KoobaServer.DeviceManager.Device do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.DeviceManager.Device

  @valid_includes ~w(android iphone)

  schema "devices" do
    field(:device_token, :string)
    field(:name, :string)

    belongs_to(:user, KoobaServer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%Device{} = device, attrs) do
    device
    |> cast(attrs, [:name, :device_token])
    |> validate_required([:name, :device_token])
    |> validate_inclusion(:name, @valid_includes)
  end
end

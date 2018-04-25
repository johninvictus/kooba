defmodule KoobaServer.DeviceManagerTest do
  use KoobaServer.DataCase

  alias KoobaServer.DeviceManager

  describe "devices" do
    alias KoobaServer.DeviceManager.Device

    @valid_attrs %{device_token: "some device_token", name: "some name"}
    @update_attrs %{device_token: "some updated device_token", name: "some updated name"}
    @invalid_attrs %{device_token: nil, name: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeviceManager.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert DeviceManager.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert DeviceManager.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = DeviceManager.create_device(@valid_attrs)
      assert device.device_token == "some device_token"
      assert device.name == "some name"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeviceManager.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, device} = DeviceManager.update_device(device, @update_attrs)
      assert %Device{} = device
      assert device.device_token == "some updated device_token"
      assert device.name == "some updated name"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = DeviceManager.update_device(device, @invalid_attrs)
      assert device == DeviceManager.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = DeviceManager.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> DeviceManager.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = DeviceManager.change_device(device)
    end
  end
end

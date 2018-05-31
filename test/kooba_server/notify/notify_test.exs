defmodule KoobaServer.NotifyTest do
  use KoobaServer.DataCase

  alias KoobaServer.Notify

  describe "notifications" do
    alias KoobaServer.Notify.Notification

    @valid_attrs %{json_body: "some json_body", message: "some message"}
    @update_attrs %{json_body: "some updated json_body", message: "some updated message"}
    @invalid_attrs %{json_body: nil, message: nil}

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notify.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Notify.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notify.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Notify.create_notification(@valid_attrs)
      assert notification.json_body == "some json_body"
      assert notification.message == "some message"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notify.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      assert {:ok, notification} = Notify.update_notification(notification, @update_attrs)
      assert %Notification{} = notification
      assert notification.json_body == "some updated json_body"
      assert notification.message == "some updated message"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Notify.update_notification(notification, @invalid_attrs)
      assert notification == Notify.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notify.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notify.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notify.change_notification(notification)
    end
  end
end

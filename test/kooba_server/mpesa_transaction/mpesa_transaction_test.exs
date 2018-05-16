defmodule KoobaServer.MpesaTransactionTest do
  use KoobaServer.DataCase

  alias KoobaServer.MpesaTransaction

  describe "send_request" do
    alias KoobaServer.MpesaTransaction.SendRequest

    @valid_attrs %{convertion_id: "some convertion_id", originator_conversation_id: "some originator_conversation_id", status: "some status"}
    @update_attrs %{convertion_id: "some updated convertion_id", originator_conversation_id: "some updated originator_conversation_id", status: "some updated status"}
    @invalid_attrs %{convertion_id: nil, originator_conversation_id: nil, status: nil}

    def send_request_fixture(attrs \\ %{}) do
      {:ok, send_request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> MpesaTransaction.create_send_request()

      send_request
    end

    test "list_send_request/0 returns all send_request" do
      send_request = send_request_fixture()
      assert MpesaTransaction.list_send_request() == [send_request]
    end

    test "get_send_request!/1 returns the send_request with given id" do
      send_request = send_request_fixture()
      assert MpesaTransaction.get_send_request!(send_request.id) == send_request
    end

    test "create_send_request/1 with valid data creates a send_request" do
      assert {:ok, %SendRequest{} = send_request} = MpesaTransaction.create_send_request(@valid_attrs)
      assert send_request.convertion_id == "some convertion_id"
      assert send_request.originator_conversation_id == "some originator_conversation_id"
      assert send_request.status == "some status"
    end

    test "create_send_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MpesaTransaction.create_send_request(@invalid_attrs)
    end

    test "update_send_request/2 with valid data updates the send_request" do
      send_request = send_request_fixture()
      assert {:ok, send_request} = MpesaTransaction.update_send_request(send_request, @update_attrs)
      assert %SendRequest{} = send_request
      assert send_request.convertion_id == "some updated convertion_id"
      assert send_request.originator_conversation_id == "some updated originator_conversation_id"
      assert send_request.status == "some updated status"
    end

    test "update_send_request/2 with invalid data returns error changeset" do
      send_request = send_request_fixture()
      assert {:error, %Ecto.Changeset{}} = MpesaTransaction.update_send_request(send_request, @invalid_attrs)
      assert send_request == MpesaTransaction.get_send_request!(send_request.id)
    end

    test "delete_send_request/1 deletes the send_request" do
      send_request = send_request_fixture()
      assert {:ok, %SendRequest{}} = MpesaTransaction.delete_send_request(send_request)
      assert_raise Ecto.NoResultsError, fn -> MpesaTransaction.get_send_request!(send_request.id) end
    end

    test "change_send_request/1 returns a send_request changeset" do
      send_request = send_request_fixture()
      assert %Ecto.Changeset{} = MpesaTransaction.change_send_request(send_request)
    end
  end
end

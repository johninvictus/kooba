defmodule KoobaServerWeb.MpesaController do
  use KoobaServerWeb, :controller

  @pass "mp@sa$"

  def validation(conn, %{"pass" => pass} = params) do
    if(pass != @pass) do
      send_resp(conn, 401, "Not authorized")
    end

    send_resp(conn, 200, Poison.encode!(params))
  end

  def confirmation(conn, %{"pass" => pass} = params) do
    if(pass != @pass) do
      send_resp(conn, 401, "Not authorized")
    end

    send_resp(conn, 200, Poison.encode!(params))
  end

  def b2c(conn, %{"pass" => pass, "type" => type} = params) do
    if(pass != @pass) do
      send_resp(conn, 401, "Not authorized")
    end

    cond do
      type == "result" ->
        # extract the OriginatorConversationID, ConversationID, TransactionID
        encoded_data = params |> Poison.encode!()

      # TODO: when I have a live mpesa server
      # use get_int to get the values easy
      # check if the transaction exists on the table
      # update the table
      # send a notification and sms notifying the use the loan has been received

      type == "timeout" ->
        send_resp(conn, 401, "Can not process entity #{type}")
    end
  end
end

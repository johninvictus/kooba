defmodule KoobaServerWeb.MpesaController do
  use KoobaServerWeb, :controller
  alias KoobaServer.Repo
  alias KoobaServer.MpesaTransaction.SendMoneyRequest
  alias KoobaServer.MpesaTransaction
  alias KoobaServer.MicroFinance
  alias  KoobaServer.MicroFinance.LoanTaken
  import Ecto.Query, warn: false

  require Logger

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

  def b2c(conn, params) do
    result = params["Result"]["ResultParameters"]["ResultParameter"]
    convertion_id =  params["Result"]["ConversationID"]
    _originator_conversation_id =  params["Result"]["OriginatorConversationID"]

    _transaction = result |> Enum.at(0)
    receipts =  result |> Enum.at(1)

    Logger.info(receipts["Value"])

    # update db of mpesa transactions
    # set the loan as active
    # update the mpesa table with receipt and status (pending |> disbursed)

    qx =
      (from c in SendMoneyRequest, where: (c.convertion_id == ^convertion_id))
      |> Repo.one()

    MpesaTransaction.update_send_request(qx, %{status: "disbursed", receipt: receipts["Value"]}) #wrap in transaction

    Repo.get(LoanTaken, qx.loan_taken_id) |> MicroFinance.update_loan_taken(%{status: "active"}) #wrap in transaction


    send_resp(conn, 200, Poison.encode!(receipts["Value"]))
  end
end

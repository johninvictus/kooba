defmodule KoobaServer.Queues.MpesaLoan do
  alias KoobaServer.Mpesa
  alias KoobaServer.Money
  alias KoobaServer.MpesaTransaction
  alias KoobaServer.MicroFinance.LoanTaken

  require Logger

  def perform(params) do
    loan_taken = KoobaServer.Repo.get(LoanTaken, params["loan_id"])

    %Money{cents: cents} = loan_taken.loan_total

    # loan taken, send this via mpesa
    # b2c
    total_amount = (cents / 100) |> trunc()

    preloanded_loan = loan_taken |> KoobaServer.Repo.preload(:user)

    user = preloanded_loan.user
    pre_load_device = user |> KoobaServer.Repo.preload(:device)
    device = pre_load_device.device

    partyb =
      user.phone
      |> String.replace("+", "")
      |> String.trim()

    # logic to send
    result = Mpesa.B2c.payment_request("BusinessPayment", total_amount, partyb, "loan", "loan")
    Logger.info(result)

    case result do
      {:ok, params, _result} ->
        value = %{
          "convertion_id" => params["ConversationID"],
          "originator_conversation_id" => params["OriginatorConversationID"],
          "status" => "pending",
          "receipt" => ""
        }

        Fcmex.push(
          device.device_token,
          notification: %{
            title: "foo",
            body: "bar",
            click_action: "open_foo",
            icon: "new"
          }
        )

        MpesaTransaction.create_send_request(loan_taken, value)
        :ok

      # send notification to thr user leting
      # TODO: enable reentry
      {:error, %HTTPotion.Response{body: _body, status_code: _code}} ->
        # forcing re entry incase of errors
        :error
    end
  end
end

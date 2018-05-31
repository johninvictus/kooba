defmodule KoobaServer.Mpesa.StkPush do
  alias KoobaServer.Mpesa
  alias KoobaServer.Mpesa.C2b

  def get_stk_call_back_url do
    Application.get_env(:kooba_server, :stk_call_back_url)
  end

  def get_pass_key do
    Application.get_env(:kooba_server, :pass_key)
  end

  def processrequest(
        phone_number,
        pass_key,
        amount,
        account_reference,
        transaction_desc
      ) do
    timestamp = get_timestamp()
    business_short_code = C2b.get_c2b_short_code()

    body = %{
      "BusinessShortCode" => business_short_code,
      "Password" => :base64.encode("#{business_short_code}#{pass_key}#{timestamp}"),
      "Timestamp" => timestamp,
      "TransactionType" => "CustomerPayBillOnline",
      "Amount" => amount,
      "PartyA" => phone_number,
      "PartyB" => business_short_code,
      "PhoneNumber" => phone_number,
      "CallBackURL" => get_stk_call_back_url(),
      "AccountReference" => account_reference,
      "TransactionDesc" => transaction_desc
    }

    Mpesa.post("/stkpush/v1/processrequest", body: Poison.encode!(body))
    |> Mpesa.process_response()
  end

  def query(checkout_requestId) do
    pass_key = get_pass_key()
    timestamp = get_timestamp()
    business_short_code = C2b.get_c2b_short_code()

    body = %{
      "BusinessShortCode" => business_short_code,
      "Password" => :base64.encode("#{business_short_code}#{pass_key}#{timestamp}"),
      "Timestamp" => timestamp,
      "CheckoutRequestID" => checkout_requestId
    }

    MpesaElixir.post("/stkpushquery/v1/query", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end

  def get_timestamp do
    Timex.local()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{m}{s}")
  end
end

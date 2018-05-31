defmodule KoobaServer.Mpesa.B2c do
  alias KoobaServer.Mpesa
  alias KoobaServer.Mpesa.Auth

  def get_b2c_initiator do
    Application.get_env(:kooba_server, :b2c_initiator_name, "")
  end

  def get_b2c_short_code do
    Application.get_env(:kooba_server, :b2c_short_code, "")
  end

  def get_b2c_queue_time_out_url do
    Application.get_env(:kooba_server, :b2c_queue_time_out_url)
  end

  def get_b2c_result_url do
    Application.get_env(:kooba_server, :b2c_result_url)
  end

  def payment_request(command_id, amount, partyb, remarks, occasion \\ nil) do
    body = %{
      "InitiatorName" => get_b2c_initiator(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => get_b2c_short_code(),
      "PartyB" => partyb,
      "Remarks" => remarks,
      "QueueTimeOutURL" => get_b2c_queue_time_out_url(),
      "ResultURL" => get_b2c_result_url(),
      "Occasion" => occasion
    }

    Mpesa.post("/b2c/v1/paymentrequest", body: Poison.encode!(body))
    |> Mpesa.process_response()
  end
end

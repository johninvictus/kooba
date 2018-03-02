defmodule KoobaServer.Guardian.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    body = %{error: %{message: to_string(type)}} |> Poison.encode!()
    send_resp(conn, 401, body)
  end
end

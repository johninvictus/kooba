defmodule KoobaServerWeb.MpesaController do
  use KoobaServerWeb, :controller

  def validation(conn, params) do
    send_resp(conn, 200, Poison.encode!(params))
  end

  def confirmation(conn, params) do
    send_resp(conn, 200, Poison.encode!(params))
  end
end

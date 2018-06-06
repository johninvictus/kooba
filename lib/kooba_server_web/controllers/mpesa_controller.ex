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

  def b2c(conn, params) do
    send_resp(conn, 200, Poison.encode!(params))
  end
end

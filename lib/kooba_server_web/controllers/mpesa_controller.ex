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
    if(pass == @pass) do
      send_resp(conn, 401, "Not authorized")
    end

    send_resp(conn, 200, Poison.encode!(params))
  end

  def b2c(conn, %{"pass" => pass, "type" => type} = params) do
    if(pass != @pass) do
      send_resp(conn, 401, "Not authorized")
    end

    cond do
      type == "timeout" ->
        send_resp(conn, 200, Poison.encode!(params))

      type == "result" ->
        send_resp(conn, 200, Poison.encode!(params))

      true ->
        send_resp(conn, 401, "Not authorized")
    end
  end
end

defmodule KoobaServerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use KoobaServerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(KoobaServerWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(KoobaServerWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :credential_error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(KoobaServerWeb.ErrorView, "error.json", message: message)
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:not_found)
    |> render(KoobaServerWeb.ErrorView, "error.json", message: reason)
  end
end

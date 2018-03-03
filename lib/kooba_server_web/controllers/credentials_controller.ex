defmodule KoobaServerWeb.CredentialsController do
  use KoobaServerWeb, :controller
  alias KoobaServer.Guardian
  alias KoobaServer.Accounts

  action_fallback(KoobaServerWeb.FallbackController)

  def action(conn, _params) do
    # now resource will be available in all actions
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  def index(conn, _params, user) do
    send_resp(conn, 200, user.phone)
  end

  def create(conn, %{"credentials" => credentials}, user) do
    with {:ok, details} <- Accounts.create_user_detail(user, credentials) do
      conn
      |> put_status(:created)
      |> render("show.json", credentials: details)
    end
  end
end

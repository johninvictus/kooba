defmodule KoobaServerWeb.CredentialsController do
  use KoobaServerWeb, :controller
  alias KoobaServer.Guardian

  def action(conn, _params) do
    # now resource will be available in all actions
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  def index(conn, _params, user) do
    send_resp(conn, 200, user.phone)
  end
end

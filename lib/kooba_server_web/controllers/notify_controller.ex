defmodule KoobaServerWeb.NotifyController do
  use KoobaServerWeb, :controller

  alias KoobaServer.Notify

  action_fallback(KoobaServerWeb.FallbackController)

  def action(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, user])
  end

  def index(conn, params, user) do
    page =
      params
      |> Notify.pagenated_notifications(user.id)

    # Scrivener.Headers.paginate(page) //add this to the
    conn
    |> put_status(:ok)
    |> render("index.json", notifications: page.entries, pagination: page)
  end
end

defmodule KoobaServerWeb.DeviceController do
  use KoobaServerWeb, :controller

  alias KoobaServer.DeviceManager

  action_fallback(KoobaServerWeb.FallbackController)

  def action(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  def index(conn, _params, user) do
    device = DeviceManager.get_user_device(user)
    render(conn, "index.json", device: device)
  end

  @doc """
  This will be used to add or update a new item
  """
  def create(conn, params, user) do
    with {:ok, device} <- DeviceManager.add_update_device(user, params) do
      render(conn, "index.json", device: device)
    end
  end
end

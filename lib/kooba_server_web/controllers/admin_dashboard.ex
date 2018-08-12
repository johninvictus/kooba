defmodule KoobaServerWeb.AdminDashboard do
  use KoobaServerWeb, :controller

  alias KoobaServer.MicroFinance

  def action(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  def index(conn, _params, user) do
    # list the total number loans taken clients
    # number of late loans
    # number of loans not late
    late_loans_count = MicroFinance.count_all_late_loans()
    all_taken_loans = MicroFinance.count_all_taken_loans()
    pending_loans = MicroFinance.count_all_pending_loans()
    active_loans = MicroFinance.count_all_active_loans()




  end
end

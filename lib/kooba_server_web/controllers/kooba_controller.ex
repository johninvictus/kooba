defmodule KoobaServerWeb.KoobaController do
  use KoobaServerWeb, :controller

  alias KoobaServer.MicroFinance

  action_fallback(KoobaServerWeb.FallbackController)

  def action(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  @doc """
  Return response of loan limit, settings, loan status,
  """
  def state(conn, _params, user) do
    has_loan = MicroFinance.user_has_loan?(user.id)
    user_loan_limit = MicroFinance.get_user_loan_limit(user)
    loan_settings = MicroFinance.list_loan_settings()

    # TODO: implement this logic later
    suspension_info = %{suspended: false, until: ""}

    render(conn, "state.json", %{
      loan_limit: user_loan_limit,
      loan_settings: loan_settings,
      suspension_info: suspension_info,
      has_loan: has_loan
    })
  end
end

defmodule KoobaServerWeb.KoobaController do
  use KoobaServerWeb, :controller

  alias KoobaServer.MicroFinance
  alias KoobaServer.Accounts

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

  def loan(conn, _params, user) do
    cond do
      MicroFinance.user_has_loan?(user.id) ->
        loan_taken = MicroFinance.get_user_open_loan(user)
        loan_payments = MicroFinance.get_loan_payments(user)
        loan_setting = MicroFinance.get_loan_setting!(user.id)

        render(conn, "loan.json", %{
          loan_taken: loan_taken,
          loan_payments: loan_payments,
          loan_setting: loan_setting
        })

      true ->
        {:error, "All loans are cleared"}
    end
  end

  def profile(conn, params, user) do
    # user
    # credentials
    # loan taken list
    user_details = Accounts.get_user_detail(user)
    page = MicroFinance.paginate_user_loan_taken(user.id, params)

    conn
    |> render(KoobaServerWeb.KoobaView, "profile.json", %{
      user: user,
      credentials: user_details,
      loans_taken: page.entries
    })
  end
end

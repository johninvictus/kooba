defmodule KoobaServerWeb.LoanController do
  use KoobaServerWeb, :controller

  alias KoobaServer.MicroFinance.RequestLoan
  alias KoobaServer.MicroFinance

  action_fallback(KoobaServerWeb.FallbackController)

  @doc """
  Expand the actions to contain the user
  """
  def action(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    apply(__MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  @doc """
  Request a loan that is not more than the limit
  > check
   1. Users request does not go behold the limit
   2. User loan status is active

   params laon amount and loan setting id
  """
  def request(conn, params, user) do
    case RequestLoan.request(user, params) do
      {:ok, _result} ->
        conn
        |> put_status(:ok)
        |> render("request.json", %{message: "Loan successifully taken"})

      {:error, changeset} ->
        {:error, changeset}

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> render(KoobaServerWeb.ErrorView, "error.json", %{
          message: "An error occured while submiting your loan request, please try again"
        })
    end
  end

  def history(conn, params, user) do
    page = MicroFinance.paginate_user_loan_taken(user.id, params)

    conn
    |> put_status(:ok)
    |> render(
      KoobaServerWeb.KoobaView,
      "loan_history.json",
      loans_taken: page.entries,
      pagination: page
    )
  end
end

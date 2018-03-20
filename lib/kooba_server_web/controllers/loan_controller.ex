defmodule KoobaServerWeb.LoanController do
  use KoobaServerWeb, :controller

  @doc """
  Expand the actions to contain the user
  """
  def action(conn, _params) do
    resource = Guardian.Plug.current_claims(conn)
    apply( __MODULE__, action_name(conn), [conn, conn.params, resource])
  end

  @doc """
  Request a loan that is not more than the limit
  > check
   1. Users request does not go behold the limit
   2. User loan status is active

   params laon amount and loan setting id
  """
  def request(conn, params, user) do
    
  end
end

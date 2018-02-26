defmodule KoobaServerWeb.SessionController do
  use KoobaServerWeb, :controller

  require Logger

  alias KoobaServer.Accounts
  alias KoobaServer.AccountKit
  alias KoobaServer.Guardian
  # alias KoobaServer.AccountKit.AccessToken.Token

  action_fallback(KoobaServerWeb.FallbackController)

  def create(conn, %{"authorization_code" => auth_code}) do
    # check if an account is present
    # if not present store it and then fetch token and store it or update it if present
    # return jwt using guardian

    with {:ok, access_token_bundle} <- AccountKit.get_user_access_token(auth_code),
         {:ok, account_data} <- AccountKit.get_user_info(access_token_bundle.access_token) do
      # check if number from server matches with the one sent
      # check if user exist if :true render response :false insert the details and then return response

        case Accounts.get_user_by_phone(account_data.number) do
          user when is_map(user) ->
            Accounts.update_user(user, %{access_token: access_token_bundle.access_token})

            new_connection = Guardian.Plug.sign_in(conn, user)
            token = Guardian.Plug.current_token(new_connection)

            details_provided = user |> user_details_provided()

            new_connection
            |> put_status(:ok)
            |> render(
              "show.json",
              token: token,
              user: user,
              details_provided: details_provided
            )

          nil ->
            new_user = %{
              phone: account_data.number,
              access_token: access_token_bundle.access_token,
              country_prefix: account_data.country_prefix,
              national_number: account_data.national_number
            }

            with {:ok, user} <- Accounts.create_user(new_user) do
              new_connection = Guardian.Plug.sign_in(conn, user)
              token = Guardian.Plug.current_token(new_connection)

              details_provided = user |> user_details_provided()

              new_connection
              |> put_status(:created)
              |> render(
                "show.json",
                token: token,
                user: user,
                details_provided: details_provided
              )
            end
        end
    else
      {:error, reason} ->
        {:error, :credential_error, reason}
    end
  end

  defp user_details_provided(user) do
    case Accounts.get_user_detail(user) do
      nil ->
        false

      _ ->
        true
    end
  end
end

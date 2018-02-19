defmodule KoobaServerWeb.SessionController do
  use KoobaServerWeb, :controller

  require Logger

  alias KoobaServer.Accounts
  alias KoobaServer.AccountKit
  alias KoobaServer.Guardian
  # alias KoobaServer.AccountKit.AccessToken.Token

  def create(conn, %{"authorization_code" => auth_code, "number" => number}) do
    # check if an account is present
    # if not present store it and then fetch token and store it or update it if present
    # return jwt using guardian

    with {:ok, access_token_bundle} <- AccountKit.get_user_access_token(auth_code),
         {:ok, account_data} <- AccountKit.get_user_info(access_token_bundle.access_token) do
      # check if number from server matches with the one sent
      # check if user exist if :true render response :false insert the details and then return response
      if account_data.number == number do
        case Accounts.get_user_by_phone(number) do
          {:ok, user} ->
            update_user = %{user | access_token: access_token_bundle.access_token}

            conn |> render("show.json", auth_code: "All is well")

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

              new_connection
              |> put_status(:created)
              |> render("show.json", auth_code: "guardian token: #{token}")
            end
        end
      else
        conn |> render("show.json", auth_code: "")
      end
    else
      {:error, reason} ->
        conn |> render("show.json", auth_code: "#{reason}error #{number}")
    end
  end
end

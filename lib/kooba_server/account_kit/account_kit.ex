defmodule KoobaServer.AccountKit do
  @moduledoc """
  It will be use to contact the facebook API
  """
  alias KoobaServer.AccountKit.AccessToken
  alias KoobaServer.AccountKit.AccountInfo

  @doc """
  get access token when given auth code

  return {:ok, token} or return {:error, reason}
  """
  def get_user_access_token(authorization_code) do
    authorization_code |> AccessToken.get()
  end

  def get_user_info(access_token) do
    access_token |> AccountInfo.get()
  end
end

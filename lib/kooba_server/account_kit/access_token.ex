defmodule KoobaServer.AccountKit.AccessToken do
  defmodule Token do
    defstruct id: nil, access_token: nil, token_refresh_interval_sec: nil
  end

  @base_url "https://graph.accountkit.com/v1.3/access_token?"
  def get(auth_token) do
    auth_token
    |> build_url()
    |> get_response()
  end

  def build_url(auth_token) do
    "#{@base_url}grant_type=authorization_code&code=#{auth_token}&access_token=AA|#{get_app_id()}|#{
      app_secret()
    }"
  end

  def get_response(url) do
    try do
      HTTPoison.get!(url) |> decode_response()
    rescue
      _ ->
        {:error, "Error occured"}
    end
  end

  def decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    result = body |> Poison.decode()

    case result do
      {:ok, response} ->
        access_token = %Token{
          id: response["id"],
          access_token: response["access_token"],
          token_refresh_interval_sec: response["token_refresh_interval_sec"]
        }

        {:ok, access_token}

      _ ->
        {:error, "Error occured"}
    end
  end

  def decode_response(%HTTPoison.Response{body: body, status_code: 400}) do
    reason = Poison.decode!(body) |> get_in(["error", "message"])
    {:error, reason}
  end

  def decode_response(_) do
    {:error, "An error occured"}
  end

  defp get_app_id do
    get_config(:facebook_app_id)
  end

  defp app_secret do
    get_config(:app_secret)
  end

  defp get_config(key) do
    results =
      Application.get_env(:kooba_server, :facebook_account_kit)
      |> Enum.into(Map.new())

    get_in(results, [key])
  end
end

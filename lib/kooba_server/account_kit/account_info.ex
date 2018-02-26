defmodule KoobaServer.AccountKit.AccountInfo do
  @base_url "https://graph.accountkit.com/v1.3/me/?"

  defmodule AccountData do
    defstruct id: nil,
              number: nil,
              country_prefix: nil,
              national_number: nil,
              application_id: nil
  end

  def get(access_token) do
    access_token
    |> create_url()
    |> get_response()
  end

  def create_url(access_token) do
    "#{@base_url}access_token=#{URI.encode(access_token)}"
  end

  def get_response(url) do
    # try do
    url |> HTTPoison.get( [], [timeout: 50_000, recv_timeout: 50_000]) |> decode_response()
    # rescue
    #   _ ->
    #     {:error, "Error occured when gettting API #rescue"}
    # end
  end

  def decode_response(%HTTPoison.Response{body: body, status_code: 200}) do
    case body |> Poison.decode() do
      {:ok, response} ->
        account = %AccountData{
          id: response["id"],
          number: get_in(response, ["phone", "number"]),
          country_prefix: get_in(response, ["phone", "country_prefix"]),
          national_number: get_in(response, ["phone", "national_number"]),
          application_id: get_in(response, ["application", "id"])
        }

        {:ok, account}

      _ ->
        {:error, "Error decoding response using Poison"}
    end
  end

  def decode_response(%HTTPoison.Response{body: body, status_code: 400}) do
    reason = Poison.decode!(body) |> get_in(["error", "message"])
    {:error, reason}
  end

  def decode_response(_) do
    {:error, "Error when decoding response #unknown response"}
  end
end

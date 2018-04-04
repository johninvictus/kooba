defmodule BlackBox do
  @base_url "http://blackbox.co.ke/vas/index.php/api"

  @type response ::
          {:ok, :jsx.json_term(), HTTPotion.Response.t()} | {integer, any, HTTPotion.Response.t()}

  @spec process_response_body(binary) :: term
  def process_response_body(""), do: nil
  def process_response_body(body), do: XmlToMap.naive_map(body)

  @spec process_response(HTTPotion.Response.t()) :: response
  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp),
    do: {status_code, process_response_body(body), resp}

  @spec get_api_key :: String.t()
  def get_api_key do
    Application.get_env(:kooba_server, :api_key)
  end

  @spec get_api_signature :: String.t()
  def get_api_signature do
    Application.get_env(:kooba_server, :api_signature)
  end

  def post(path, body \\ []) do
    params =
      [
        "api_key=" <> URI.encode_www_form(get_api_key()),
        "api_signature=" <> URI.encode_www_form(get_api_signature())
      ] ++ body

    HTTPotion.post(url(path), body: Enum.join(params, "&"), headers: get_headers())
    |> process_response()
  end

  def url(path) do
    @base_url <> path
  end

  def get_headers do
    [
      "User-Agent": "blackbox",
      "Content-Type": "application/x-www-form-urlencoded"
    ]
  end
end

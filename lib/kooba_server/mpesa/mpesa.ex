defmodule KoobaServer.Mpesa do
  def get_api_base_url do
    Application.get_env(:mpesa_elixir, :api_url, "")
  end
end

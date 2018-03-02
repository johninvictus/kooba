defmodule KoobaServer.Guardian do
  use Guardian, otp_app: :kooba_server

  alias KoobaServer.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    user = Accounts.get_user!(claims["sub"])
    {:ok, user}
  end
end

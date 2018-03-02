defmodule KoobaServer.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :kooba_server,
    module: KoobaServer.Guardian,
    error_handler: KoobaServer.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end

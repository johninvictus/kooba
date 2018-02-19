defmodule KoobaServerWeb.Router do
  use KoobaServerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :unauthorized do
    plug(:fetch_session)
  end

  pipeline :authorized do
    plug(:fetch_session)

    plug(
      Guardian.Plug.Pipeline,
      module: KoobaServer.Guardian,
      error_handler: KoobaServer.Guardian.AuthErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource)
  end

  scope "/api", KoobaServerWeb do
    pipe_through(:api)

    get("/", WelcomeController, :index)
    post("/sessions", SessionController, :create)
    resources("/users", UserController, except: [:new, :edit])
  end
end

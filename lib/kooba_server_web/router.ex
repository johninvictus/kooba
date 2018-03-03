defmodule KoobaServerWeb.Router do
  use KoobaServerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :api_auth do
    plug(KoobaServer.Guardian.AuthPipeline)
  end

  scope "/api", KoobaServerWeb do
    pipe_through(:api)

    get("/", WelcomeController, :index)
    post("/sessions", SessionController, :create)
  end

  scope "/api", KoobaServerWeb do
    pipe_through([:api, :api_auth])

    resources("/users", UserController, except: [:new, :edit])
    get("/user/credentials", CredentialsController, :index)
    # update or create
    post("/user/credentials", CredentialsController, :create)
  end
end

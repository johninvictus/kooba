defmodule KoobaServerWeb.Router do
  use KoobaServerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :exq do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
    plug(ExqUi.RouterPlug, namespace: "exq")
  end

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

    get("loan/request", LoanController, :request)
  end

  scope "/exq", ExqUi do
    pipe_through(:exq)
    forward("/", RouterPlug.Router, :index)
  end
end

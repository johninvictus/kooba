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

    # post the device id, get user devices,
    # post and get are working
    # TODO: complete :update, :show, :delete
    resources("user/device", DeviceController, except: [:new, :edit])

    # update or create
    post("/user/credentials", CredentialsController, :create)

    get("loan/request", LoanController, :request)

    # show loan state, limit, loans settings, purnishment
    get("kooba/state", KoobaController, :state)
  end

  scope "/mpesa", KoobaServerWeb do
    pipe_through(:api)

    post("/callbacks/confirmation", MpesaController, :confirmation)
    post("/callbacks/validation", MpesaController, :validation)
  end

  scope "/exq", ExqUi do
    pipe_through(:exq)
    forward("/", RouterPlug.Router, :index)
  end
end

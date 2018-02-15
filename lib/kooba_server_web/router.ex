defmodule KoobaServerWeb.Router do
  use KoobaServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KoobaServerWeb do
    pipe_through :api
  end
end

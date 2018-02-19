defmodule KoobaServerWeb.WelcomeController do
  use KoobaServerWeb, :controller

  def index(conn, _params) do
    conn |> render("index.json")
  end
end

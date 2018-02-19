defmodule KoobaServerWeb.SessionView do
  use KoobaServerWeb, :view

  def render("show.json", %{auth_code: auth_code}) do
    %{
      token: auth_code
    }
  end
end

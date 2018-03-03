defmodule KoobaServerWeb.CredentialsView do
  use KoobaServerWeb, :view
  alias KoobaServerWeb.CredentialsView

  def render("show.json", %{credentials: credentials}) do
    %{credentials: render_one(credentials, CredentialsView, "credentials.json")}
  end

  def render("credentials.json", %{credentials: credentials}) do
    %{
      full_name: credentials.full_name,
      national_card: credentials.national_card,
      birth_date: credentials.birth_date
    }
  end
end

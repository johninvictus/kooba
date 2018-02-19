defmodule KoobaServerWeb.WelcomeView do
  use KoobaServerWeb, :view

  def render("index.json", _param) do
    %{
      name: "Kooba lending application API server.",
      version: "1.0"
    }
  end
end

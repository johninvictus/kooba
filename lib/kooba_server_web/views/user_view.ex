defmodule KoobaServerWeb.UserView do
  use KoobaServerWeb, :view
  alias KoobaServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      country_prefix: user.country_prefix,
      national_number: user.national_number,
      phone: user.phone
    }
  end
end

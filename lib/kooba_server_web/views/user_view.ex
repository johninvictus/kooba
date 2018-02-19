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
    %{id: user.id,
      phone: user.phone,
      access_token: user.access_token}
  end
end

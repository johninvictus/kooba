defmodule KoobaServerWeb.SessionView do
  use KoobaServerWeb, :view

  def render("show.json", %{token: token, user: user, details_provided: details}) do
    %{
      meta: %{
        token: token,
        duration: "30 days"
      },
      user: render_one(user, KoobaServerWeb.UserView, "user.json"),
      user_details_provided: details
    }
  end
end

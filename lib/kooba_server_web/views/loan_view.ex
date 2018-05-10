defmodule KoobaServerWeb.LoanView do
  def render("request.json", %{message: message}) do
    %{
      data: %{
        message: message
      }
    }
  end
end

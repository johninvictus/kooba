defmodule KoobaServerWeb.KoobaView do
  use KoobaServerWeb, :view

  alias KoobaServerWeb.KoobaView

  require Logger

  def render("state.json", %{
        loan_limit: loan_limit,
        loan_settings: loan_settings,
        suspension_info: suspension_info,
        has_loan: has_loan
      }) do
    %{
      data: %{
        has_loan: has_loan,
        suspension_info:
          render_one(suspension_info, KoobaView, "suspension_info.json", as: :suspension_info),
        loan_limit: render_one(loan_limit, KoobaView, "loan_limit.json", as: :loan_limit),
        loan_settings:
          render_many(loan_settings, KoobaView, "loan_setting.json", as: :loan_setting)
      }
    }
  end

  def render("suspension_info.json", %{suspension_info: suspension_info}) do
    %{suspended: suspension_info.suspended, until: suspension_info.until}
  end

  def render("loan_limit.json", %{loan_limit: loan_limit}) do
    %KoobaServer.Money{cents: cents, currency: currency} = loan_limit.amount

    %{
      id: loan_limit.id,
      amount: %{
        cents: cents,
        currency: currency
      },
      status: loan_limit.status
    }
  end

  def render("loan_setting.json", %{loan_setting: loan_setting}) do
    %KoobaServer.Money{cents: cents, currency: currency} = loan_setting.min_amount

    %{
      id: loan_setting.id,
      name: loan_setting.name,
      interest: loan_setting.interest,
      term: loan_setting.term,
      term_measure: loan_setting.term_measure,
      min_amount: %{
        cents: cents,
        currency: currency
      }
    }
  end
end

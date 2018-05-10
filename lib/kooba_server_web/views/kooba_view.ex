defmodule KoobaServerWeb.KoobaView do
  use KoobaServerWeb, :view

  alias KoobaServerWeb.KoobaView
  alias KoobaServer.Money

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

  def render("loan.json", %{loan_taken: loan_taken, loan_payments: loan_payments, loan_setting: loan_setting}) do
    %{
      data: %{
        loan_taken: render_one(loan_taken, __MODULE__, "loan_taken.json", as: :loan_taken),
        loan_setting: render_one(loan_setting, __MODULE__, "loan_setting.json", as: :loan_setting),
        loan_payments:
          render_many(loan_payments, __MODULE__, "loan_payments.json", as: :loan_payment)
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

  def render("loan_taken.json", %{loan_taken: loan_taken}) do
    %KoobaServer.Money{cents: loan_amount_cent, currency: loan_amount_currency} =
      loan_taken.loan_amount

    %KoobaServer.Money{cents: loan_interest_cent, currency: loan_interest_currency} =
      loan_taken.loan_interest

    %KoobaServer.Money{cents: loan_total_cent, currency: loan_total_currency} =
      loan_taken.loan_total

    %KoobaServer.Money{cents: late_fee_cent, currency: late_fee_currency} = loan_taken.late_fee

    %{
      id: loan_taken.id,
      next_payment_id: loan_taken.next_payment_id,
      status: loan_taken.status,
      notified_count: loan_taken.notified_count,
      loan_amount: %{
        cents: loan_amount_cent,
        currency: loan_amount_currency
      },
      loan_interest: %{
        cents: loan_interest_cent,
        currency: loan_interest_currency
      },
      loan_total: %{
        cents: loan_total_cent,
        currency: loan_total_currency
      },
      late_fee: %{
        cents: late_fee_cent,
        currency: late_fee_currency
      }
    }
  end

  def render("loan_payments.json", %{loan_payment: loan_payment}) do
    %KoobaServer.Money{cents: amount_cent, currency: amount_currency} = loan_payment.amount

    %KoobaServer.Money{cents: payment_remaining_cent, currency: payment_remaining_currency} =
      loan_payment.payment_remaining

    %{
      id: loan_payment.id,
      status: loan_payment.status,
      type: loan_payment.type,
      notified_count: loan_payment.notified_count,
      amount: %{
        cents: amount_cent,
        currency: amount_currency
      },
      payment_remaining: %{
        cents: payment_remaining_cent,
        currency: payment_remaining_currency
      },
      payment_schedue: format_naive_date(loan_payment.payment_schedue)
    }
  end

  defp format_naive_date(date) do
    "#{date.day}-#{date.month}-#{date.year}"
  end
end

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     KoobaServer.Repo.insert!(%KoobaServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias KoobaServer.MicroFinance.LoanSetting
alias KoobaServer.Repo

settings = [
  %{name: "4 weekly payments", term_measure: "weekly", frequency: 1, term: 28, interest: 12, late_interest: 13, min_amount_string: "0.00"},
  %{name: "2 two weekly payments", term_measure: "weekly", frequency: 2, term: 28, interest: 13, late_interest: 14, min_amount_string: "0.00"},
  %{name: "1 monthly payment", term_measure: "monthly", frequency: 1, term: 28, interest: 14, late_interest: 15, min_amount_string: "0.00"},
  %{name: "2 monthly payment", term_measure: "monthly", frequency: 1, term: 56, interest: 16, late_interest: 17, min_amount_string: "6000.00"}
]

for loan_setting <- settings do
Repo.get_by(LoanSetting, name: loan_setting.name) ||
 LoanSetting.build(%LoanSetting{}, loan_setting)
 |> Repo.insert!
end

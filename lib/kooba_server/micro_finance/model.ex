defmodule KoobaServer.MicroFinance.Model do
  @moduledoc """
  This is just a short cut for reducing import boiler plate code
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias KoobaServer.{
        MicroFinance.RequestLoan,
        Money,
        MicroFinance.LoanLimit,
        Accounts.User,
        Repo,
        MicroFinance.LoanSetting,
        MicroFinance.LoanTaken
      }
    end
  end
end

defmodule KoobaServer.Repo do
  use Ecto.Repo, otp_app: :kooba_server
  use Scrivener, page_size: 10

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def transaction_with_isolation(fun_or_multi, opts) do
    false = KoobaServer.Repo.in_transaction?()
    level = Keyword.fetch!(opts, :level)

    transaction(
      fn ->
        {:ok, _} =
          Ecto.Adapters.SQL.query(Bank.Repo, "SET TRANSACTION ISOLATION LEVEL #{level}", [])

        case transaction(fun_or_multi, opts) do
          {:ok, result} -> {:ok, result}
          {:error, reason} -> KoobaServer.Repo.rollback(reason)
        end
        |> unwrap_transaction_result
      end,
      opts
    )
  end

  defp unwrap_transaction_result({:ok, result}), do: result
  defp unwrap_transaction_result(other), do: other
end

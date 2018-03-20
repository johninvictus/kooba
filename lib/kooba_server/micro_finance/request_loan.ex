defmodule KoobaServer.MicroFinance.RequestLoan do
  use KoobaServer.MicroFinance.Model


  embedded_schema do
    field :payment_period_id, :integer
    field :amount, :string
  end

  def changeset(struct, params \\ Map.new) do
    struct
    |> cast(params, [:payment_period_id, :amount])
    |> validate_required([:payment_period_id, :amount])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "is invalid")
  end

  def request(%User{} = user, params) do
    changeset = changeset(%RequestLoan{}, params);

    if changeset.valid? do
      data = apply_changes(changeset)
      # //TODO: find the best way to change currency
      amount = Money.new("#{data.amount} "<> "KSH")
      # check if the amount is within the loan limit
      with :ok <- check_within_limit(user, amount) do
        :ok
      else
          {:error, :limit_exceeded} ->
            add_error(changeset, :amount, "loan limit exceeded")
            {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  defp check_within_limit(%User{} = user, %Money{} = amount) do
    limit = user |> Repo.preload(:loan_limit)

    %KoobaServer.Money{cents: cents} = limit

    if(amount.cents <= cents) do
      :ok
    else
      {:error, :limit_exceeded}
    end
  end

end

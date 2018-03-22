defmodule KoobaServer.MicroFinance.RequestLoan do
  use KoobaServer.MicroFinance.Model

  embedded_schema do
    field(:payment_period_id, :integer)
    field(:amount, :string)
  end

  def changeset(struct, params \\ Map.new()) do
    struct
    |> cast(params, [:payment_period_id, :amount])
    |> validate_required([:payment_period_id, :amount])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "is invalid")
  end

  def request(%User{} = user, params) do
    changeset = changeset(%RequestLoan{}, params)

    if changeset.valid? do
      data = apply_changes(changeset)
      # //TODO: find the best way to change currency
      amount = Money.new("#{data.amount} " <> "KSH")
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

  def generate_payments_list(%LoanTaken{} = loan_taken, amount) do
    data = loan_taken |> Repo.preload(:loan_setting)
    loan_settings = data.loan_setting

    cond do
      loan_settings.term_measure && "weekly" ->
        # 7 days
        # how many times to divide
        factor = loan_settings.term / (7 * loan_settings.frequency)
        # add 1 to remove the round of error
        equal_payments =
          (loan_taken.loan_total / factor + 1)
          |> trunc()
          |> convert_to_money()

        # // TODO: does not factor incase of float days may result into reduced payment days
        offset_days = (loan_settings.term / factor) |> trunc()
        generate_payments(equal_payments, factor, offset_days)

      loan_settings.term_measure && "monthly" ->
        # 28 days
        :ok
    end
  end

  defp generate_payments(%Money{} = equal_payments, factor, offset_days) do
  end

  def generate(%Money{} = equal_payments, 0, offset_days, curent_date, list), do: list

  def generate(%Money{} = equal_payments, factor, offset_days, curent_date, list) do
    # generate(equal_payments, factor - 1, offset_days, )
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

  def convert_to_money(amount) do
    Money.new(Integer.to_string(amount) <> ".00 " <> "KSH")
  end
end

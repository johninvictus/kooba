defmodule KoobaServer.MicroFinance.RequestLoan do
  use KoobaServer.MicroFinance.Model
  use Timex

  embedded_schema do
    field(:payment_period_id, :integer)
    field(:amount, :integer)

    field(:amount_string, :string)
  end

  def changeset(struct, params \\ Map.new()) do
    struct
    |> cast(params, [:payment_period_id, :amount_string])
    |> validate_required([:payment_period_id, :amount_string])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "is invalid")
    |> put_amount_int()
  end

  defp put_amount_int(changeset) do
    if changeset.valid? do
      data = apply_changes(changeset)
      {amount, _} = Float.parse(data.amount_string)
      put_change(changeset, :amount, trunc(amount))
    else
      changeset
    end
  end

  def request(%User{} = user, params) do
    changeset = changeset(%RequestLoan{}, params)

    if changeset.valid? do
      data = apply_changes(changeset)
      # //TODO: find the best way to change currency
      amount = Money.new("#{data.amount_string} KSH")
      # check if the amount is within the loan limit
      with :ok <- check_within_limit(user, amount) do
        setting = Repo.get!(LoanSetting, data.payment_period_id)

        interest = (data.amount * (setting.interest / 100)) |> trunc()
        total_loan = interest + data.amount
        # use ecto multi to avoid errors
        loan_taken = %LoanTaken{
          late_fee: convert_to_money(0),
          loan_amount: amount,
          loan_interest: convert_to_money(interest),
          loan_total: convert_to_money(total_loan),
          next_payment_id: 0,
          notified_count: 0,
          status: "pending",
          user: user,
          loan_setting: setting
        }

        # wrap in Ecto.Multi to allow rollback
        multi =
          Ecto.Multi.new()
          |> Ecto.Multi.insert(:loan_taken, loan_taken)
          |> Ecto.Multi.run(:loan_payments, fn %{loan_taken: loan_taken} ->
            list_map =
              generate_payments_list(loan_taken)
              |> Enum.map(fn param -> generate_payment_struct(param) end)
              |> Enum.reverse()

            # Enum.map(list_map, fn trans -> KoobaServer.Repo.insert!(trans) end)
            # KoobaServer.Repo.insert_all(LoanPayment, list_map)

             payments = Enum.map(list_map, fn transaction ->
              LoanPayment.generate_loan_payment(loan_taken, transaction)
              |> KoobaServer.Repo.insert!()
            end)

            {:ok, %{loan_taken | loan_payments: payments}}
          end)

        case Repo.transaction(multi) do
          {:ok, result} ->
            result

          error ->
            error
        end
      else
        {:error, :limit_exceeded} ->
          add_error(changeset, :amount, "loan limit exceeded")
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  def generate_payment_struct(param) do
    {:ok, date_string} = param.payment_schedue |> Timex.format("%Y-%m-%d", :strftime)
    %{param | payment_schedue: date_string}
    # Map.put(param, :loans_taken_id, loan_taken.id)
  end

  def generate_payments_list(%LoanTaken{} = loan_taken) do
    loan_settings = loan_taken.loan_setting

    length =
      cond do
        loan_settings.term_measure && "weekly" ->
          7

        loan_settings.term_measure && "monthly" ->
          28
      end

    # 7 days
    # how many times to divide
    # // TODO: make sure it does not return float number
    factor = (loan_settings.term / (length * loan_settings.frequency)) |> trunc()
    # add 1 to remove the round of error
    equal_payments =
      (convert_money_to_integer(loan_taken.loan_total) / factor + 1)
      |> trunc()
      |> convert_to_money()

    # // TODO: does not factor incase of float days may result into reduced payment days
    offset_days = (loan_settings.term / factor) |> trunc()

    generate_payments(equal_payments, factor, offset_days)
  end

  def generate_payments(%Money{} = equal_payments, factor, offset_days) do
    generate(equal_payments, factor, offset_days, Timex.today(), [])
  end

  def generate(_equal_payments, 0, _offset_days, _curent_date, list), do: list

  def generate(%Money{} = equal_payments, factor, offset_days, curent_date, list) do
    current = Timex.shift(curent_date, days: offset_days)

    generate(equal_payments, factor - 1, offset_days, current, [
      generate_map(current, equal_payments) | list
    ])
  end

  defp generate_map(current_date, equal_payments) do
    %{
      amount_string: convert_money_to_float_string(equal_payments),
      payment_schedue: current_date,
      status: "unpaid",
      type: "normal",
      notified_count: 0
    }
  end

  defp check_within_limit(%User{} = user, %Money{} = amount) do
    limit = user |> Repo.preload(:loan_limit)

    %KoobaServer.MicroFinance.LoanLimit{amount: %KoobaServer.Money{cents: cents}} =
      limit.loan_limit

    if(amount.cents <= cents) do
      :ok
    else
      {:error, :limit_exceeded}
    end
  end

  def convert_to_money(amount) do
    Money.new(Integer.to_string(amount) <> ".00 " <> "KSH")
  end

  def convert_money_to_integer(%Money{} = amount) do
    money_string = Money.to_string(amount) |> String.split(" ") |> Enum.at(0)
    {amount, _} = money_string |> Float.parse()
    trunc(amount)
  end

  def convert_money_to_float_string(%Money{} = amount) do
    Money.to_string(amount) |> String.split(" ") |> Enum.at(0)
  end
end
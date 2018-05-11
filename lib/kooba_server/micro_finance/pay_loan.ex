defmodule KoobaServer.MicroFinance.PayLoan do
  use KoobaServer.MicroFinance.Model

  require Logger

  @doc """
  Pay loan
  """
  def pay_loan(%User{} = user, %Money{} = amount) do
    # // TODO: since I have no idea for payments lemme learn first
    # check if the user already has a loan
    if MicroFinance.user_has_loan?(user.id) do
      case MicroFinance.get_loan_payments(user) do
        [] ->
          # //TODO: push to wallet
          IO.puts("wallet")

        loan_payments when is_list(loan_payments) ->
          payments_list =
            list_loan_payments(loan_payments, amount)
            |> Enum.reverse()

          # update data and anticipate error
          loan_id = List.first(payments_list).loan_taken_id

          Repo.transaction(fn ->
            with {:ok, transactions} <- update_transactions(payments_list),
                 {:ok, _loan_taken} <- MicroFinance.close_loan(loan_id) do
              transactions
            else
              _ ->
                # //TODO: maybe push to wallet
                Repo.rollback("Error occured, database rollback")
            end
          end)

        _ ->
          :error
      end
    else
      # Add to wallet
      # //TODO: push to wallet
    end
  end

  def update_transactions(payments) do
    list =
      payments
      |> Enum.map(fn transaction ->
        loan_payment = MicroFinance.get_loan_payment!(transaction.id)

        {:ok, update} =
          LoanPayment.generate_update_changeset(loan_payment, update_struct_amount(transaction))
          |> Repo.update()

        update
      end)

    {:ok, list}
  end

  defp update_struct_amount(transaction) do
    tran_map = Map.from_struct(transaction)

    map = %{tran_map | amount_string: Money.no_currency_to_string(tran_map.amount)}
    %{map | payment_schedue_string: NaiveDateTime.to_string(transaction.payment_schedue)}
  end

  defp list_loan_payments(loan_payments, amount) do
    # generate a payed transaction list plus the remaining cash
    iterate_payments(loan_payments, amount, [])
  end

  defp iterate_payments([], _amount, cumm), do: cumm

  defp iterate_payments([head | trail], amount, cumm) do
    {new_payment, new_amount} = pay_payment(head, amount)
    iterate_payments(trail, new_amount, [new_payment | cumm])
  end

  defp pay_payment(payment, %Money{cents: cash} = amount) do
    # %Money{cents: paycents} = payment.payment_remaining
    # # cash is bigger
    # if paycents <= cash do
    #   remaining_cash = Money.subtract(amount, payment.payment_remaining)
    #   update_status = %{payment | status: "paid"}
    #
    #   Logger.debug("Greater value ::")
    #
    #   {Map.put(
    #      update_status,
    #      :payment_remaining_string,
    #      Money.no_currency_to_string(%Money{cents: 0, currency: "KSH"})
    #    ), remaining_cash}
    # else
    #   # payment is higher
    #   payment_remainder = Money.subtract(payment.payment_remaining, amount)
    #
    #   Logger.debug("Lowe value ::")
    #
    #   {Map.put(
    #      payment,
    #      :payment_remaining_string,
    #      Money.no_currency_to_string(payment_remainder)
    #    ), %Money{cents: 0, currency: "KSH"}}
    # end

    %Money{cents: payment_cents} = payment.payment_remaining

    remaining_cash =
      cond do
        payment_cents <= cash && cash != 0 ->
          new_money = Money.subtract(amount, payment.payment_remaining)
          payed_money = %Money{cents: 0, currency: "KSH"}

          {payed_money, new_money}

        payment_cents > cash ->
          payed_money = Money.subtract(payment.payment_remaining, amount)
          new_money = %Money{cents: 0, currency: "KSH"}

          {payed_money, new_money}
      end

    {%Money{cents: payed_cents} = payed_money, new_money} = remaining_cash

    status =
      cond do
        payed_cents == 0 ->
          "paid"

        true ->
          "unpaid"
      end

    update_status = %{payment | status: status}

    {Map.put(update_status, :payment_remaining_string, Money.no_currency_to_string(payed_money)),
     new_money}
  end
end

defmodule KoobaServer.Queues.SmsNotification do
  def perform(message) do
    IO.puts("The task has been performed ----- #{message} ---- end")
  end
end

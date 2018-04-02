defmodule KoobaServer.Queue.Notification do
  def perform(message) do
    IO.puts "The task has been performed ----- #{message} ---- end"
  end
end

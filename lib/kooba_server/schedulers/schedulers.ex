defmodule KoobaServer.Schedulers do
  use Quantum.Scheduler, otp_app: :kooba_server

  def send do
    IO.puts "logger mate"
  end

end

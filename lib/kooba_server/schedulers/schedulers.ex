defmodule KoobaServer.Schedulers do
  use Quantum.Scheduler,
   otp_app: :kooba_server

  def send do
   Exq.enqueue(Exq, "notification", KoobaServer.Queue.Notification, ["John"])
  end

end

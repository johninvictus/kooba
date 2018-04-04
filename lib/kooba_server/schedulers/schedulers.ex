defmodule KoobaServer.Schedulers do
  use Quantum.Scheduler, otp_app: :kooba_server

  def send do
    Exq.enqueue(Exq, "sms_notification", KoobaServer.Queues.SmsNotification, ["John"])
  end
end

defmodule KoobaServer.BlackBox.Message do
  alias KoobaServer.BlackBox

  @type response :: {:ok, map, HTTPotion.Response.t()} | {integer, any, HTTPotion.Response.t()}

  def new(recipient, message, sender, keyword, scheduled_date \\ "") do
    %{
      recipient: recipient,
      message: message,
      sender: sender,
      keyword: keyword,
      scheduled_date: scheduled_date
    }
  end

  @spec build_messages(map) :: String.t()
  def build_messages(message) when is_map(message) do
    list = [message | []]
    build_messages(list)
  end

  @spec build_messages(list) :: String.t()
  def build_messages(messages) when is_list(messages) do
    messages =
      Enum.reduce(messages, "", fn sms, cumm ->
        cumm <> build_single_sms(sms)
      end)

    "<request>#{messages}</request>"
  end

  @spec build_single_sms(map) :: String.t()
  defp build_single_sms(message) do
    "<sms>
    <recipient> #{message.recipient}</recipient>
    <message> #{message.message}</message>
    <sender> #{message.sender}</sender>
    <keyword>#{message.keyword}</keyword>
    <scheduled_date> #{message.scheduled_date}</scheduled_date>
    </sms>"
  end

  @spec send(String.t()) :: response
  def send(messages) when is_binary(messages) do
    BlackBox.post("/send_sms", ["messages=#{URI.encode_www_form(messages)}"])
  end

  @spec balance() :: response
  def balance do
    BlackBox.post("/get_balance")
  end
end

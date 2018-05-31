defmodule KoobaServer.Notify.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.Notify.Notification

  schema "notifications" do
    field(:json_body, :string)
    field(:message, :string)

    belongs_to(:user, KoobaServer.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:message, :json_body])
    |> validate_required([:message, :json_body])
  end
end

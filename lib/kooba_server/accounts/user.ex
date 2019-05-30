defmodule KoobaServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias KoobaServer.MicroFinance.LoanLimit
  alias KoobaServer.Accounts.User

  @user_types ~w(1 2)

  schema "users" do
    field(:access_token, :string)
    field(:phone, :string)
    field(:country_prefix, :integer)
    field(:national_number, :integer)

    # user type 1: admin 2: user
    field :user_type, :integer
    field :active, :boolean #true or false
    field :password, :string #password for normal user
    field :card_provided, :boolean
    field :password_string, :string

    has_one(:user_details, KoobaServer.Accounts.UserDetail)
    has_one(:device, KoobaServer.DeviceManager.Device)
    has_one(:loan_limit, KoobaServer.MicroFinance.LoanLimit)
    has_many(:loans, KoobaServer.MicroFinance.LoanTaken)
    has_many(:notifications, KoobaServer.Notify.Notification)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone, :access_token, :country_prefix, :national_number, :user_type, :active, :password_string])
    |> validate_required([:phone, :access_token])
    |> unique_constraint(:phone)
    |> validate_inclusion(:user_type, @user_types)
    |> check_if_admin()

  end

  def build(attrs \\ Map.new()) do
    changeset(%User{}, attrs)
    |> put_assoc(:loan_limit, LoanLimit.build_initial_limit())
  end

  defp check_if_admin(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: changeset} ->
        if changeset.user_type == 1 do
          changeset |> put_change(:active, true)
          changeset |> put_change(:card_provided, true)

          changeset
          |> validate_required([:password_string])
          |> validate_length(:password_string, min: 6)
          |> put_password()
        else
          changeset
        end
      _->
        changeset
    end
  end

  defp put_password(changeset) do
    with %Ecto.Changeset{valid?: true, changes: changeset} do
      hash_password = Argon2.hash_pwd_salt(changeset.password_string)
      changeset |> put_change(:password, hash_password)
    end
  end

end

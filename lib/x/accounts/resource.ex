defmodule X.Accounts.Account do
  use Ecto.Schema

  alias Ecto.Changeset

  def fields do
    __MODULE__.__schema__(:fields)
  end

  @generated_fields [:id, :inserted_at, :updated_at]
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "accounts" do
    has_one :user, X.Users.User

    field :email, :string
    field :password, :string

    timestamps()
  end

  def changeset(struct \\ %X.Accounts.Account{}, params) do
    struct
    |> Changeset.cast(params, fields() -- @generated_fields)
    |> Changeset.validate_required(fields() -- @generated_fields)
    |> Changeset.validate_length(:password, min: 4)
    |> Changeset.validate_length(:email, max: 150)
    |> Changeset.unique_constraint(:email)
    |> hash_password()
  end

  @spec to_json(map()) :: map()
  def to_json(struct), do: struct |> to_json(:public)

  @spec to_json(map(), :public | :sensitive) :: map()
  def to_json(struct, _permission = :public) do
    struct
    |> Map.take([:user, :email])
  end

  def to_json(struct, _permission = :sensitive) do
    struct
    |> Map.take([
      :id,
      :user,
      :email,
      :inserted_at,
      :updated_at
    ])
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> Changeset.change(password: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end

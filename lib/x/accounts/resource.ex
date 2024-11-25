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

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Create new account.
  """
  def changeset(params) do
    fields = fields() -- @generated_fields

    %X.Accounts.Account{}
    |> Changeset.cast(params, fields)
    |> validate(fields)
    |> hash_password()
  end

  @doc """
  Update existent account.
  """
  def changeset(struct, params) do
    fields = fields() -- @generated_fields -- [:password]

    struct
    |> Changeset.cast(params, fields)
    |> validate(fields)
    |> hash_password()
  end

  def validate(changeset, fields) do
    changeset
    |> Changeset.unique_constraint(:email)
    |> Changeset.validate_required(fields)
    |> Changeset.validate_length(:password, min: 4)
    |> Changeset.validate_length(:email, max: 150)
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
    |> Changeset.change(password_hash: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end

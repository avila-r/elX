defmodule X.Users.User do
  use Ecto.Schema

  alias Ecto.Changeset

  def fields, do: __MODULE__.__schema__(:fields)

  @generated_fields [:id, :inserted_at, :updated_at]
  @optional_fields [:bio, :gender]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    belongs_to :account, X.Accounts.Account

    field :name, :string
    field :gender, :string
    field :bio, :string

    timestamps()
  end

  def changeset(struct \\ %X.Users.User{}, params) do
    struct
    |> Changeset.cast(params, fields() -- @generated_fields)
    |> Changeset.validate_required((fields() -- @generated_fields) -- @optional_fields)
  end
end

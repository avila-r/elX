defmodule X.Comments.Comment do
  alias Ecto.Changeset
  use Ecto.Schema

  def fields do
    __MODULE__.__schema__(:fields)
  end

  @generated_fields [:id, :inserted_at, :updated_at, :like]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    belongs_to :user, X.Users.User
    belongs_to :post, X.Posts.Post

    field :content, :string

    has_many :like, X.Likes.Like

    timestamps()
  end

  def changeset(struct \\ %X.Comments.Comment{}, params) do
    fields = fields() -- @generated_fields

    struct
    |> Changeset.cast(params, fields)
    |> Changeset.validate_required(fields)
    |> Changeset.validate_length(:content, max: 248)
  end

  @spec to_json(map()) :: map()
  def to_json(struct), do: struct |> to_json(:public)

  @spec to_json(map(), :public | :sensitive) :: map()
  def to_json(struct, _permission = :public) do
    struct
    |> Map.take([:user, :post, :content, :like])
  end

  def to_json(struct, _permission = :sensitive) do
    struct
    |> Map.take([
      :id,
      :user,
      :post,
      :content,
      :like,
      :inserted_at,
      :updated_at
    ])
  end
end

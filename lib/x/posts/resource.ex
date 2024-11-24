defmodule X.Posts.Post do
  alias Ecto.Changeset
  use Ecto.Schema

  def fields, do: __MODULE__.__schema__(:fields)

  @generated_fields [:id, :inserted_at, :updated_at]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    belongs_to :user, X.Users.User

    field :title, :string
    field :content, :string

    has_many :comment, X.Comments.Comment
    has_many :like, X.Likes.Like

    timestamps()
  end

  def changeset(struct \\ %X.Posts.Post{}, params) do
    fields = fields() -- @generated_fields

    struct
    |> Changeset.cast(params, fields)
    |> Changeset.validate_required(fields)
    |> Changeset.validate_length(:title, max: 54)
    |> Changeset.validate_length(:content, max: 248)
  end

  @spec to_json(map()) :: map()
  def to_json(struct), do: struct |> to_json(:public)

  @spec to_json(map(), :public | :sensitive) :: map()
  def to_json(struct, _permission = :public) do
    struct
    |> Map.take([:title, :content, :comment, :like])
  end

  def to_json(struct, _permission = :sensitive) do
    struct
    |> Map.take([
      :id,
      :title,
      :content,
      :comment,
      :like,
      :inserted_at,
      :updated_at
    ])
  end
end

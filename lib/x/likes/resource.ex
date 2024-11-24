defmodule X.Likes.Like do
  alias Ecto.Changeset
  use Ecto.Schema

  def fields do
    __MODULE__.__schema__(:fields)
  end

  @generated_fields [:id, :inserted_at, :updated_at]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "likes" do
    belongs_to :user, X.Users.User
    belongs_to :post, X.Posts.Post
    belongs_to :comment, X.Comments.Comment

    timestamps()
  end

  def changeset(struct \\ %X.Likes.Like{}, params) do
    struct
    |> Changeset.cast(params, fields())
    |> Changeset.validate_required(fields() -- @generated_fields)
  end

  @spec to_json(map()) :: map()
  def to_json(struct), do: struct |> to_json(:public)

  @spec to_json(map(), :public | :sensitive) :: map()
  def to_json(struct, _permission = :public) do
    struct
    |> Map.take([:user, :post, :comment])
  end

  def to_json(struct, _permission = :sensitive) do
    struct
    |> Map.take([
      :id,
      :user,
      :post,
      :comment,
      :inserted_at,
      :updated_at
    ])
  end
end

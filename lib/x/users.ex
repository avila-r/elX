defmodule X.Users do
  alias X.Repo
  alias X.Users.User

  def list do
    with users when users != [] <- User |> Repo.all() do
      {:ok, users}
    else
      [] -> {:error, "no users found"}
      _ -> {:error, "unexpected error occurred"}
    end
  end

  def insert(params) do
    case params |> Ecto.build_assoc(:user) |> User.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> valid |> Repo.insert()
      invalid -> {:error, invalid}
    end
  end

  def update(params) do
    case get(params) do
      {:ok, user} ->
        user
        |> User.changeset(params)
        |> Repo.update()

      {:error, _reason} = error ->
        error
    end
  end

  def delete(params) do
    with {:ok, user} <- get(params),
         {:ok, _} <- Repo.delete(user) do
      {:ok}
    else
      {:error, _reason} = error -> error
    end
  end

  def get(%{"id" => id}) when is_integer(id) do
    case User |> Repo.get(id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(%{"email" => email}) when is_binary(email) do
    case User |> Repo.get_by(email: email) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(id) when is_integer(id) do
    case User |> Repo.get(id) do
      nil -> {:error, "user not found"}
      user -> {:ok, user}
    end
  end

  def get(%{"id" => _id}), do: {:error, "id must be an integer"}
  def get(%{"email" => _email}), do: {:error, "missing or malformed email"}
  def get(_id), do: {:error, "missing or invalid id"}
end

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

  def get(params) do
    with {:ok, id} <- params |> X.Utils.get_field("id"),
         {:ok, _id} <- id |> X.Utils.is_integer() do
      case User |> Repo.get(id) |> Repo.preload(:account) do
        nil -> {:error, "user not found"}
        user -> {:ok, user}
      end
    else
      {:error, _reason} = failure -> failure
    end
  end

  def insert(params) do
    case params |> Ecto.build_assoc(:user) |> User.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> valid |> Repo.insert()
      invalid -> {:error, invalid}
    end
  end

  def update(params) do
    with {:ok, existent} <- get(params) do
      existent
      |> Repo.preload(:account)
      |> User.changeset(params)
      |> Repo.update()
    else
      {:error, _reason} = error -> error
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
end

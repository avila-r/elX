defmodule X.Accounts do
  alias X.Repo
  alias X.Accounts.Account

  def list do
    with accounts when accounts != [] <- Account |> Repo.all() do
      {:ok, accounts}
    else
      [] -> {:error, "no accounts found"}
      _ -> {:error, "unexpected error occurred"}
    end
  end

  def insert(params) do
    case params |> Account.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> valid |> Repo.insert()
      invalid -> {:error, invalid}
    end
  end

  def update(params) do
    case get(params) do
      {:ok, account} ->
        account
        |> Account.changeset(params)
        |> Repo.update()

      {:error, _reason} = error ->
        error
    end
  end

  def delete(params) do
    with {:ok, account} <- get(params),
         {:ok, _} <- Repo.delete(account) do
      {:ok}
    else
      {:error, _reason} = error -> error
    end
  end

  def get(%{"id" => id}) when is_integer(id) do
    case Account |> Repo.get(id) do
      nil -> {:error, "account not found"}
      account -> {:ok, account}
    end
  end

  def get(%{"email" => email}) when is_binary(email) do
    case Account |> Repo.get_by(email: email) do
      nil -> {:error, "account not found"}
      account -> {:ok, account}
    end
  end

  def get(id) when is_integer(id) do
    case Account |> Repo.get(id) do
      nil -> {:error, "account not found"}
      account -> {:ok, account}
    end
  end

  def get(%{"id" => _id}), do: {:error, "id must be an integer"}
  def get(%{"email" => _email}), do: {:error, "missing or malformed email"}
  def get(_id), do: {:error, "missing or invalid id"}
end

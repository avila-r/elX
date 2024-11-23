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

  def get(params) do
    with {:ok, id} <- params |> X.Utils.get_field("id"),
         {:ok, _id} <- id |> X.Utils.is_integer() do
      case Account |> Repo.get(id) do
        nil -> {:error, "account not found"}
        account -> {:ok, account}
      end
    else
      {:error, _reason} = error -> error
    end
  end

  def insert(params) do
    case params |> Account.changeset() do
      %Ecto.Changeset{valid?: true} = valid -> valid |> Repo.insert()
      invalid -> {:error, invalid}
    end
  end

  def update(params) do
    with {:ok, account} <- get(params) do
      account
      |> Account.changeset(params)
      |> Repo.update()
    else
      {:error, _reason} = error -> error
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
end

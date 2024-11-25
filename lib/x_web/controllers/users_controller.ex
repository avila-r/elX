defmodule XWeb.UsersController do
  alias X.{Users, Users.User}
  use XWeb, :controller

  action_fallback XWeb.FallbackController

  def index(conn, _params) do
    case Users.list() do
      {:ok, users} ->
        conn
        |> json(users |> Enum.map(&Users.User.to_json/1))

      {:error, message} ->
        conn
        |> error(:not_found, message: message)
    end
  end

  def show(conn, params) do
    case params |> Users.get() do
      {:ok, user} ->
        conn
        |> json(user |> User.to_json())

      {:error, reason} ->
        conn
        |> error(:not_found, message: reason)
    end
  end

  def create(conn, params) do
    case params |> Users.insert() do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user |> User.to_json())

      {:error, changeset} ->
        conn
        |> error(:unprocessable_entity, changeset: changeset)
    end
  end

  def update(conn, params) do
    case params |> Users.update() do
      {:ok, user} ->
        conn
        |> json(user |> User.to_json())

      {:error, changeset} ->
        conn
        |> error(:unprocessable_entity, changeset: changeset)
    end
  end

  def delete(conn, params) do
    case params |> Users.delete() do
      {:ok} ->
        conn
        |> send_resp(:no_content, "")

      {:error, reason} ->
        conn
        |> error(:bad_request, message: reason)
    end
  end

  defp error(conn, status, error),
    do:
      conn
      |> put_status(status)
      |> put_view(XWeb.ErrorJSON)
      |> render(:error, error)
end

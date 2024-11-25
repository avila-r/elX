defmodule XWeb.FallbackController do
  use XWeb, :controller

  def call(conn, changeset = %Ecto.Changeset{}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: XWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(json: XWeb.ErrorJSON)
    |> render(:error, message: reason)
  end

  def call(conn, error = %Postgrex.Error{}) do
    conn
    |> put_status(:internal_server_error)
    |> render(:error, message: error.message)
  end
end

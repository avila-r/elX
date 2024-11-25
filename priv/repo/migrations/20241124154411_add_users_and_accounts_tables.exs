defmodule X.Repo.Migrations.AddUsersAndAccountsTables do
  use Ecto.Migration

  @users_table :users
  @accounts_table :accounts

  def change do
    create table(@accounts_table, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :password, :string, null: false
      timestamps()
    end

    create unique_index(@accounts_table, [:email])

    create table(@users_table, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :account_id, references(@accounts_table, type: :binary_id, on_delete: :delete_all),
        null: false

      add :name, :string, null: false
      add :gender, :string
      add :bio, :string
      timestamps()
    end

    create index(@users_table, [:account_id])
  end
end

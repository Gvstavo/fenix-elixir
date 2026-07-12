defmodule Fenix.Repo.Migrations.CreateUsuarios do
  use Ecto.Migration

  def change do
    create table(:usuarios) do
      add :email, :string, null: false, collate: :nocase,
        check: %{name: "usuarios_email_check", expr: "email LIKE '%@%'"}
      add :senha_hash, :string, null: false,
        check: %{name: "usuarios_senha_check", expr: "length(senha_hash) >= 1"}
      add :foto, :string
      add :role, :string, null: false, default: "leitor",
        check: %{
          name: "usuarios_role_check",
          expr: "role IN ('administrador', 'editor', 'leitor')"
        }

      timestamps(type: :utc_datetime)
    end

    create unique_index(:usuarios, [:email])
  end
end

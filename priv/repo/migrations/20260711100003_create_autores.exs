defmodule Fenix.Repo.Migrations.CreateAutores do
  use Ecto.Migration

  def change do
    create table(:autores) do
      add :nome, :string, null: false, collate: :nocase,
        check: %{name: "autores_nome_check", expr: "length(trim(nome)) > 0"}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:autores, [:nome])
  end
end

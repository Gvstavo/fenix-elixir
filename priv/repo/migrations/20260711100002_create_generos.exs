defmodule Fenix.Repo.Migrations.CreateGeneros do
  use Ecto.Migration

  def change do
    create table(:generos) do
      add :nome, :string, null: false, collate: :nocase,
        check: %{name: "generos_nome_check", expr: "length(trim(nome)) > 0"}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:generos, [:nome])
  end
end

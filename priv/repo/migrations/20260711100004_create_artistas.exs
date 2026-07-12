defmodule Fenix.Repo.Migrations.CreateArtistas do
  use Ecto.Migration

  def change do
    create table(:artistas) do
      add :nome, :string, null: false, collate: :nocase,
        check: %{name: "artistas_nome_check", expr: "length(trim(nome)) > 0"}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:artistas, [:nome])
  end
end

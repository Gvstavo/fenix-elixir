defmodule Fenix.Repo.Migrations.CreatePaginas do
  use Ecto.Migration

  def change do
    create table(:paginas) do
      add :capitulo_id, references(:capitulos, on_delete: :delete_all), null: false
      add :numero, :integer, null: false,
        check: %{name: "paginas_numero_check", expr: "numero > 0"}
      add :conteudo_texto, :string
      add :imagem, :string

      timestamps(type: :utc_datetime)
    end

    create index(:paginas, [:capitulo_id])
    create unique_index(:paginas, [:capitulo_id, :numero])
  end
end

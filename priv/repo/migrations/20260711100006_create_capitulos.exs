defmodule Fenix.Repo.Migrations.CreateCapitulos do
  use Ecto.Migration

  def change do
    create table(:capitulos) do
      add :obra_id, references(:obras, on_delete: :delete_all), null: false
      add :numero, :integer, null: false,
        check: %{name: "capitulos_numero_check", expr: "numero > 0"}
      add :titulo, :string
      add :thumbnail, :string

      timestamps(type: :utc_datetime)
    end

    create index(:capitulos, [:obra_id])
    create unique_index(:capitulos, [:obra_id, :numero])
  end
end

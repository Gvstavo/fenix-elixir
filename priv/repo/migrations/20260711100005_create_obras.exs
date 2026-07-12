defmodule Fenix.Repo.Migrations.CreateObras do
  use Ecto.Migration

  def change do
    create table(:obras) do
      add :titulo, :string, null: false,
        check: %{name: "obras_titulo_check", expr: "length(trim(titulo)) > 0"}
      add :ano, :integer,
        check: %{name: "obras_ano_check", expr: "ano IS NULL OR (ano >= 1900 AND ano <= 2100)"}
      add :sinopse, :string
      add :thumbnail, :string
      add :status, :string, null: false, default: "em_andamento",
        check: %{
          name: "obras_status_check",
          expr: "status IN ('em_andamento', 'concluido', 'hiato')"
        }
      add :visualizacoes, :integer, null: false, default: 0,
        check: %{
          name: "obras_visualizacoes_check",
          expr: "visualizacoes >= 0"
        }
      add :adulto, :boolean, null: false, default: false
      add :tipo, :string, null: false,
        check: %{name: "obras_tipo_check", expr: "tipo IN ('manhwa', 'novel')"}

      timestamps(type: :utc_datetime)
    end

    create index(:obras, [:tipo])
    create index(:obras, [:status])
  end
end

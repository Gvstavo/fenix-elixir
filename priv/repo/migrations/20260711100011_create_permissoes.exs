defmodule Fenix.Repo.Migrations.CreatePermissoes do
  use Ecto.Migration

  def change do
    create table(:permissoes) do
      add :usuario_id, references(:usuarios, on_delete: :delete_all), null: false
      add :obra_id, references(:obras, on_delete: :delete_all), null: false
      add :tipo, :string, null: false, default: "editor",
        check: %{name: "permissoes_tipo_check", expr: "tipo IN ('editor')"}

      timestamps(type: :utc_datetime)
    end

    create index(:permissoes, [:usuario_id])
    create index(:permissoes, [:obra_id])
    create unique_index(:permissoes, [:usuario_id, :obra_id, :tipo])
  end
end

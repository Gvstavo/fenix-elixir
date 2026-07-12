defmodule Fenix.Repo.Migrations.CreateFavoritos do
  use Ecto.Migration

  def change do
    create table(:favoritos) do
      add :usuario_id, references(:usuarios, on_delete: :delete_all), null: false
      add :obra_id, references(:obras, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:favoritos, [:usuario_id])
    create index(:favoritos, [:obra_id])
    create unique_index(:favoritos, [:usuario_id, :obra_id])
  end
end

defmodule Fenix.Repo.Migrations.CreateObraArtistas do
  use Ecto.Migration

  def change do
    create table(:obra_artistas, primary_key: false) do
      add :obra_id, references(:obras, on_delete: :delete_all), null: false
      add :artista_id, references(:artistas, on_delete: :delete_all), null: false
    end

    create unique_index(:obra_artistas, [:obra_id, :artista_id])
    create index(:obra_artistas, [:artista_id])
  end
end

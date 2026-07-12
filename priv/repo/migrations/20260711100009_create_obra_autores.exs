defmodule Fenix.Repo.Migrations.CreateObraAutores do
  use Ecto.Migration

  def change do
    create table(:obra_autores, primary_key: false) do
      add :obra_id, references(:obras, on_delete: :delete_all), null: false
      add :autor_id, references(:autores, on_delete: :delete_all), null: false
    end

    create unique_index(:obra_autores, [:obra_id, :autor_id])
    create index(:obra_autores, [:autor_id])
  end
end

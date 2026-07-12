defmodule Fenix.Repo.Migrations.CreateObraGeneros do
  use Ecto.Migration

  def change do
    create table(:obra_generos, primary_key: false) do
      add :obra_id, references(:obras, on_delete: :delete_all), null: false
      add :genero_id, references(:generos, on_delete: :delete_all), null: false
    end

    create unique_index(:obra_generos, [:obra_id, :genero_id])
    create index(:obra_generos, [:genero_id])
  end
end

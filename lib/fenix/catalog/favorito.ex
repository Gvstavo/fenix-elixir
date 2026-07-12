defmodule Fenix.Catalog.Favorito do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.{Accounts.Usuario, Catalog.Obra}

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "favoritos" do
    belongs_to :usuario, Usuario
    belongs_to :obra, Obra

    timestamps(type: :utc_datetime)
  end

  def changeset(favorito, attrs) do
    favorito
    |> cast(attrs, [:usuario_id, :obra_id])
    |> validate_required([:usuario_id, :obra_id])
    |> unique_constraint([:usuario_id, :obra_id])
  end
end

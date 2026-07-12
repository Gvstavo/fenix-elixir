defmodule Fenix.Catalog.Artista do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Catalog.Obra

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "artistas" do
    field :nome, :string

    many_to_many :obras, Obra, join_through: "obra_artistas"

    timestamps(type: :utc_datetime)
  end

  def changeset(artista, attrs) do
    artista
    |> cast(attrs, [:nome])
    |> validate_required([:nome])
    |> validate_length(:nome, min: 1, max: 120)
    |> update_change(:nome, &String.trim/1)
    |> unique_constraint(:nome)
  end
end

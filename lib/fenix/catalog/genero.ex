defmodule Fenix.Catalog.Genero do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Catalog.Obra

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "generos" do
    field :nome, :string

    many_to_many :obras, Obra, join_through: "obra_generos"

    timestamps(type: :utc_datetime)
  end

  def changeset(genero, attrs) do
    genero
    |> cast(attrs, [:nome])
    |> validate_required([:nome])
    |> validate_length(:nome, min: 1, max: 60)
    |> update_change(:nome, &String.trim/1)
    |> unique_constraint(:nome)
  end
end

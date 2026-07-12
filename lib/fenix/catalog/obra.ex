defmodule Fenix.Catalog.Obra do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Constant
  alias Fenix.{Accounts.Permissao, Catalog, Content}

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "obras" do
    field :titulo, :string
    field :ano, :integer
    field :sinopse, :string
    field :thumbnail, :string
    field :status, Ecto.Enum, values: Constant.obra_status(), default: Constant.default_obra_status()
    field :visualizacoes, :integer, default: 0
    field :adulto, :boolean, default: false
    field :tipo, Ecto.Enum, values: Constant.obra_tipos()

    has_many :capitulos, Content.Capitulo, on_delete: :delete_all
    has_many :permissoes, Permissao, on_delete: :delete_all
    has_many :favoritos, Catalog.Favorito, on_delete: :delete_all

    many_to_many :generos, Catalog.Genero, join_through: "obra_generos", on_replace: :delete
    many_to_many :autores, Catalog.Autor, join_through: "obra_autores", on_replace: :delete
    many_to_many :artistas, Catalog.Artista, join_through: "obra_artistas", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(obra, attrs) do
    obra
    |> cast(attrs, [:titulo, :ano, :sinopse, :thumbnail, :status, :visualizacoes, :adulto, :tipo])
    |> validate_required([:titulo, :tipo])
    |> validate_length(:titulo, min: 1, max: 200)
    |> validate_number(:ano, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2100)
    |> validate_number(:visualizacoes, greater_than_or_equal_to: 0)
  end
end

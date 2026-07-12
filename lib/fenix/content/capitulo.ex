defmodule Fenix.Content.Capitulo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.{Catalog.Obra, Content.Pagina}

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "capitulos" do
    field :numero, :integer
    field :titulo, :string
    field :thumbnail, :string

    belongs_to :obra, Obra
    has_many :paginas, Pagina, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  def changeset(capitulo, attrs) do
    capitulo
    |> cast(attrs, [:numero, :titulo, :thumbnail, :obra_id])
    |> validate_required([:numero, :obra_id])
    |> validate_number(:numero, greater_than: 0)
    |> unique_constraint([:obra_id, :numero])
  end
end

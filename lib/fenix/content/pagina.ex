defmodule Fenix.Content.Pagina do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Content.Capitulo

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "paginas" do
    field :numero, :integer
    field :conteudo_texto, :string
    field :imagem, :string

    belongs_to :capitulo, Capitulo

    timestamps(type: :utc_datetime)
  end

  def changeset(pagina, attrs) do
    pagina
    |> cast(attrs, [:numero, :conteudo_texto, :imagem, :capitulo_id])
    |> validate_required([:numero, :capitulo_id])
    |> validate_number(:numero, greater_than: 0)
    |> unique_constraint([:capitulo_id, :numero])
  end
end

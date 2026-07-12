defmodule Fenix.Accounts.Permissao do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Constant
  alias Fenix.{Accounts.Usuario, Catalog.Obra}

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "permissoes" do
    field :tipo, Ecto.Enum, values: Constant.permissao_tipos(), default: :editor

    belongs_to :usuario, Usuario
    belongs_to :obra, Obra

    timestamps(type: :utc_datetime)
  end

  def changeset(permissao, attrs) do
    permissao
    |> cast(attrs, [:tipo, :usuario_id, :obra_id])
    |> validate_required([:tipo, :usuario_id, :obra_id])
    |> unique_constraint([:usuario_id, :obra_id, :tipo])
  end
end

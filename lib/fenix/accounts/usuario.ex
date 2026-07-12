defmodule Fenix.Accounts.Usuario do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fenix.Constant

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :integer

  schema "usuarios" do
    field :email, :string
    field :senha_hash, :string
    field :foto, :string
    field :role, Ecto.Enum, values: Constant.roles(), default: Constant.default_role()

    has_many :permissoes, Fenix.Accounts.Permissao, on_delete: :delete_all
    has_many :favoritos, Fenix.Catalog.Favorito, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  def changeset(usuario, attrs) do
    usuario
    |> cast(attrs, [:email, :senha_hash, :foto, :role])
    |> validate_required([:email, :senha_hash, :role])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 160)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
  end
end

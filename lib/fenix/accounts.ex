defmodule Fenix.Accounts do
  @moduledoc """
  Contexto de usuários e permissões. Autenticação é implementada em 0.2.0.
  """

  import Ecto.Query

  alias Fenix.Repo
  alias Fenix.Accounts.{Usuario, Permissao}

  def list_usuarios, do: Repo.all(Usuario)

  def get_usuario!(id), do: Repo.get!(Usuario, id)

  def get_usuario_by_email(email) when is_binary(email) do
    Repo.get_by(Usuario, email: String.downcase(email))
  end

  def list_permissoes_for_usuario(usuario_id) do
    Permissao
    |> where([p], p.usuario_id == ^usuario_id)
    |> Repo.all()
  end

  def list_permissoes_for_obra(obra_id) do
    Permissao
    |> where([p], p.obra_id == ^obra_id)
    |> Repo.all()
    |> Repo.preload(:usuario)
  end
end

defmodule Fenix.Catalog do
  @moduledoc """
  Contexto de catálogo: obras, gêneros, autores, artistas, favoritos.
  """

  import Ecto.Query

  alias Fenix.Repo
  alias Fenix.Catalog.{Obra, Genero, Autor, Artista, Favorito}

  def list_obras do
    Obra
    |> Repo.all()
    |> Repo.preload([:generos, :autores, :artistas])
  end

  def get_obra!(id) do
    Obra
    |> Repo.get!(id)
    |> Repo.preload([:generos, :autores, :artistas, :capitulos])
  end

  def list_generos, do: Repo.all(Genero)

  def get_genero!(id), do: Repo.get!(Genero, id)

  def list_autores, do: Repo.all(Autor)

  def get_autor!(id), do: Repo.get!(Autor, id)

  def list_artistas, do: Repo.all(Artista)

  def get_artista!(id), do: Repo.get!(Artista, id)

  def list_favoritos(usuario_id) do
    Favorito
    |> where([f], f.usuario_id == ^usuario_id)
    |> Repo.all()
    |> Repo.preload(obra: [:generos, :autores, :artistas])
  end
end

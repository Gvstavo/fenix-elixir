defmodule Fenix.Content do
  @moduledoc """
  Contexto de conteúdo: capítulos e páginas.
  """

  import Ecto.Query

  alias Fenix.Repo
  alias Fenix.Content.{Capitulo, Pagina}

  def list_capitulos_for_obra(obra_id) do
    Capitulo
    |> where([c], c.obra_id == ^obra_id)
    |> order_by([c], asc: c.numero)
    |> Repo.all()
    |> Repo.preload([:paginas])
    |> Enum.map(&preload_paginas_ordenadas/1)
  end

  def get_capitulo!(id) do
    Capitulo
    |> Repo.get!(id)
    |> Repo.preload([:obra, :paginas])
    |> preload_paginas_ordenadas()
  end

  def list_paginas_for_capitulo(capitulo_id) do
    Pagina
    |> where([p], p.capitulo_id == ^capitulo_id)
    |> order_by([p], asc: p.numero)
    |> Repo.all()
  end

  defp preload_paginas_ordenadas(%Capitulo{paginas: %Ecto.Association.NotLoaded{}} = capitulo) do
    capitulo
  end

  defp preload_paginas_ordenadas(%Capitulo{} = capitulo) do
    %{capitulo | paginas: Enum.sort_by(capitulo.paginas, & &1.numero)}
  end
end

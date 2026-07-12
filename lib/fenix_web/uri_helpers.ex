defmodule FenixWeb.URIHelpers do
  @moduledoc """
  Helpers para construir URLs absolutas (usadas em `og:url` e
  `<link rel="canonical">` do `<.seo>`).
  """

  alias Fenix.Constant
  alias FenixWeb.Endpoint

  @doc """
  Retorna a URL absoluta para um path relativo.

      iex> FenixWeb.URIHelpers.full_url("/obras/1")
      "http://localhost:4000/obras/1"
  """
  def full_url(path) when is_binary(path) do
    Endpoint.url() <> path
  end

  def site_name, do: Constant.site_name()
end

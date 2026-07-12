defmodule Fenix.Constant do
  @moduledoc """
  Constantes globais do Fenix. Nenhuma string mágica em outros módulos.
  """

  @roles ~w[administrador editor leitor]a
  @default_role :leitor

  @obra_status ~w[em_andamento concluido hiato]a
  @default_obra_status :em_andamento

  @obra_tipos ~w[manhwa novel]a

  @permissao_tipos ~w[editor]a

  @top_reads_limit 10
  @recent_updates_limit 12

  @default_page_size 20
  @max_page_size 100

  @max_upload_bytes 10 * 1024 * 1024
  @accepted_image_mime_types ~w[image/webp image/jpeg image/png]
  @accepted_page_mime_types ~w[image/webp]

  @site_name "Fenix"
  @site_description "Plataforma de leitura de manhwas e novels"
  @site_default_image "/images/logo-superior-fenix-scaled.png"

  def roles, do: @roles
  def default_role, do: @default_role

  def administrator, do: :administrador
  def editor, do: :editor
  def leitor, do: :leitor

  def obra_status, do: @obra_status
  def default_obra_status, do: @default_obra_status

  def obra_tipos, do: @obra_tipos
  def manhwa, do: :manhwa
  def novel, do: :novel

  def permissao_tipos, do: @permissao_tipos

  def top_reads_limit, do: @top_reads_limit
  def recent_updates_limit, do: @recent_updates_limit

  def default_page_size, do: @default_page_size
  def max_page_size, do: @max_page_size

  def max_upload_bytes, do: @max_upload_bytes
  def accepted_image_mime_types, do: @accepted_image_mime_types
  def accepted_page_mime_types, do: @accepted_page_mime_types

  def site_name, do: @site_name
  def site_description, do: @site_description
  def site_default_image, do: @site_default_image

  def manga_thumb_key(obra_id) when is_integer(obra_id) do
    "obras/#{obra_id}/capa.webp"
  end

  def manga_chapter_key(obra_id, capitulo_id)
      when is_integer(obra_id) and is_integer(capitulo_id) do
    "mangas/#{obra_id}/capitulos/#{capitulo_id}"
  end

  def manga_page_key(obra_id, capitulo_id, numero)
      when is_integer(obra_id) and is_integer(capitulo_id) and is_integer(numero) do
    "mangas/#{obra_id}/capitulos/#{capitulo_id}/#{numero_padded(numero)}.webp"
  end

  def novel_chapter_thumb_key(capitulo_id) when is_integer(capitulo_id) do
    "novels/capitulos/#{capitulo_id}/thumbnail.webp"
  end

  def profile_pic_key(usuario_id) when is_integer(usuario_id) do
    "usuarios/#{usuario_id}/profile/profile.webp"
  end

  def numero_padded(numero) when is_integer(numero) and numero >= 0 do
    numero |> Integer.to_string() |> String.pad_leading(3, "0")
  end
end

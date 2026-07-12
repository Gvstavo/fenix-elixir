defmodule FenixWeb.SEO do
  @moduledoc """
  Componente `<.seo>` que emite tags de SEO (`<title>`, `og:*`,
  `twitter:*`, `<link rel="canonical">`, `<meta name="robots">`,
  opcional `<script type="application/ld+json">`).

  Em 0.1.0 é renderizado dentro do `Layouts.app` (vai no body e
  funciona via SSR do LiveView). Em 0.5.0 refatoramos para injetar
  diretamente no `<head>` via `Phoenix.Component`.
  """

  use Phoenix.Component

  alias Fenix.Constant

  attr :title, :string, required: true
  attr :description, :string, default: nil
  attr :image, :string, default: nil
  attr :url, :string, default: nil
  attr :type, :string, default: "website"
  attr :noindex, :boolean, default: false
  attr :site_name, :string, default: Constant.site_name()
  slot :json_ld

  def seo(assigns) do
    assigns =
      assigns
      |> assign(:image, assigns.image || Constant.site_default_image())
      |> assign(:description, assigns.description || Constant.site_description())

    ~H"""
    <title>{@title} | {@site_name}</title>
    <meta name="description" content={@description} />
    <meta property="og:title" content={@title} />
    <meta property="og:description" content={@description} />
    <meta property="og:image" content={@image} />
    <meta property="og:url" content={@url} />
    <meta property="og:type" content={@type} />
    <meta property="og:site_name" content={@site_name} />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content={@title} />
    <meta name="twitter:description" content={@description} />
    <meta name="twitter:image" content={@image} />
    <link rel="canonical" href={@url} />
    <meta
      :if={@noindex}
      name="robots"
      content="noindex, nofollow"
    />
    <meta :if={!@noindex} name="robots" content="index, follow" />
    <script :if={@json_ld != []} type="application/ld+json">
      {Phoenix.HTML.raw(render_slot(@json_ld))}
    </script>
    """
  end
end

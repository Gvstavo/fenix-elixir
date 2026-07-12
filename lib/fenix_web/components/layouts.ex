defmodule FenixWeb.Layouts do
  @moduledoc """
  Layouts e helpers de template do Fenix.
  """
  use FenixWeb, :html

  embed_templates "layouts/*"

  attr :flash, :map, required: true
  attr :current_scope, :any, default: nil
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="bg-gradient-to-r from-[#d1717c] to-[#f0c382] shadow-sm">
      <div class="mx-auto flex max-w-7xl items-center gap-4 px-4 py-3 sm:px-6 lg:px-8">
        <a href="/" class="flex shrink-0 items-center">
          <img src={~p"/images/logo-superior-fenix-scaled.png"} width="36" />
        </a>

        <nav class="hidden items-center gap-6 md:flex">
          <a
            href="/"
            class="text-sm font-medium text-white/90 transition hover:text-white"
          >
            Início
          </a>
          <a
            href="/manhwas"
            class="text-sm font-medium text-white/90 transition hover:text-white"
          >
            Manhwas
          </a>
          <a
            href="/novels"
            class="text-sm font-medium text-white/90 transition hover:text-white"
          >
            Novels
          </a>
          <a
            href="/concluidos"
            class="text-sm font-medium text-white/90 transition hover:text-white"
          >
            Concluídos
          </a>
        </nav>

        <div class="flex-1">
          <form class="mx-auto max-w-md">
            <label for="search-input" class="sr-only">Buscar</label>
            <div class="relative">
              <.icon
                name="hero-magnifying-glass"
                class="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-white/80"
              />
              <input
                id="search-input"
                type="search"
                name="q"
                placeholder="Buscar manhwa..."
                disabled
                class="w-full rounded-full border-0 bg-white/20 py-2 pl-9 pr-3 text-sm text-white placeholder-white/70 shadow-inner backdrop-blur transition focus:bg-white/30 focus:outline-none focus:ring-2 focus:ring-white/40 disabled:cursor-not-allowed disabled:opacity-70"
              />
            </div>
          </form>
        </div>

        <div class="flex items-center gap-2">
          <a
            href="/entrar"
            class="rounded-full border border-white/40 bg-white/10 px-4 py-1.5 text-sm font-medium text-white backdrop-blur transition hover:bg-white/20"
          >
            Entrar
          </a>
          <a
            href="/cadastrar"
            class="rounded-full bg-white px-4 py-1.5 text-sm font-semibold text-[#d1717c] shadow-sm transition hover:bg-white/90"
          >
            Cadastrar
          </a>
        </div>
      </div>
    </header>

    <main class="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  attr :flash, :map, required: true
  attr :id, :string, default: "flash-group"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("Não conseguimos nos conectar")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Tentando reconectar")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Algo deu errado!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Tentando reconectar")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end

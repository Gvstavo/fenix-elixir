# Roadmap do Projeto Fenix

> Sistema web para gerenciamento e leitura de mangás e novels.
> Stack: Elixir 1.15+, Phoenix 1.8, Phoenix LiveView, Ecto + SQLite3, RustFS (S3) e Oban.
> Referências: `docs/001-requisitos.md`, `docs/002-der.jpeg`, `docs/layout/*.png`.

## Visão geral

| Versão | Tema | Entregas principais |
|---|---|---|
| **0.1.0** | Fundação | Migrations, schemas, layout base, SEO base, identidade visual |
| **0.2.0** | Auth + Storage | Cadastro/login, papel padrão `leitor`, `Fenix.Storage` (RustFS) |
| **0.3.0** | Admin + CRUD catálogo | Painel administrativo, CRUD de Obras/Gêneros/Autores/Artistas |
| **0.4.0** | Conteúdo | CRUD de Capítulos, upload de páginas WebP, leitor de novel (rich-text) |
| **0.5.0** | Catálogo público | Home, listagens, detalhe da obra, SEO completo |
| **0.6.0** | Comentários | Comentários em obras (RF13) e capítulos (RF14), apenas logged-in |
| **0.7.0** | Métricas | Tabela ETS para contabilização de acessos, top 10 mais lidos |
| **0.8.0** | Favoritos | Favoritar/desfavoritar, listagem de favoritos |
| **0.9.0** | Permissões | Papel `editor`, concessão de permissão por obra |
| **0.10.0** | Atalho de capítulos | Upload de capítulos via ZIP (síncrono) com regras de parsing |
| **1.0.0** | Oban + polimento | Oban processando ZIPs em background, refinamento final |

---

## Entidades (migrations geradas em 0.1.0)

| Migration | Tabelas / colunas principais |
|---|---|
| `*_create_usuarios.exs` | `usuarios` (id, `email` unique com `collate: :nocase`, `senha_hash`, `foto`, `role` enum `administrador/editor/leitor`) |
| `*_create_obras.exs` | `obras` (id, `titulo`, `ano`, `sinopse`, `thumbnail`, `status` enum, `visualizacoes`, `adulto`, `tipo` enum `manhwa/novel`) |
| `*_create_capitulos.exs` | `capitulos` (id, `obra_id`, `numero`, `titulo`, `thumbnail`) |
| `*_create_paginas.exs` | `paginas` (id, `capitulo_id`, `numero`, `conteudo_texto` para novels, `imagem` path S3 para mangás) |
| `*_create_generos_autores_artistas.exs` | `generos`, `autores`, `artistas` (id, `nome` unique com `collate: :nocase`) |
| `*_create_obra_generos.exs` | Junção N:N `obra_generos` |
| `*_create_obra_autores.exs` | Junção N:N `obra_autores` |
| `*_create_obra_artistas.exs` | Junção N:N `obra_artistas` |
| `*_create_permissoes.exs` | `permissoes` (id, `usuario_id`, `obra_id`, `tipo` enum `editor`) |
| `*_create_favoritos.exs` | `favoritos` (id, `usuario_id`, `obra_id`, unique em `[usuario_id, obra_id]`) |

### Migration adicional em 0.6.0

| Migration | Tabelas / colunas principais |
|---|---|
| `*_create_comentarios.exs` | `comentarios` (id, `usuario_id` FK, `obra_id` FK nullable, `capitulo_id` FK nullable, `texto`, timestamps). **Check** garante que exatamente um entre `obra_id` e `capitulo_id` está preenchido. Indexes em `(obra_id)`, `(capitulo_id)`, `(usuario_id)`. |

> Restrições de check são aplicadas **na definição de coluna** (ex.: `add :email, :string, collate: :nocase, check: %{...}`), conforme restrição do `ecto_sqlite3` documentada no AGENTS.md.

---

## Identidade visual (estabelecida em 0.1.0)

Gradiente do menu/cabeçalho público (de `docs/layout/`):

```css
/* assets/css/app.css */
:root {
  --fenix-gradient-from: #d1717c;
  --fenix-gradient-to: #f0c382;
}
```

Aplicação no `Layouts.app` público: `bg-gradient-to-r from-[#d1717c] to-[#f0c382]`.
Aplicação no painel admin: topbar compacta com o mesmo gradiente (`logo-superior-fenix-scaled`).

Demais cores derivadas são registradas como variáveis Tailwind no `app.css`. Sem dependência de daisyUI.

---

## Requisitos não funcionais acompanhados em todas as versões

- **RNF01** Web — atendido pela stack Phoenix.
- **RNF02** Validação de papéis — `administrador`, `editor`, `leitor`, aplicada via `current_scope` e on_mount hooks.
- **RNF03** Usabilidade — microinterações, estados de carregamento, mensagens claras.
- **RNF04** Responsividade — layouts mobile-first com Tailwind v4.
- **RNF05** Performance — LiveView streams, ETS para hot reads, `Repo.transaction(..., mode: :immediate)`.
- **RNF06 (novo) SEO nas páginas públicas** — atendido por componentes `<.seo>`, JSON-LD, sitemap e robots. Detalhes por versão abaixo.

---

## 0.1.0 — Fundação, schema e identidade visual

### Migrations
- Gerar todas as migrations listadas na seção **Entidades**.
- Aplicar `collate: :nocase` em e-mails e nomes únicos (limitações do SQLite3).
- Adicionar checks via coluna (não via `ALTER TABLE ADD CONSTRAINT`).

### Configuração e infraestrutura
- `config :fenix, Fenix.Repo, default_transaction_mode: :immediate` em `config.exs`.
- `Fenix.Application` inicia `Fenix.Repo`, `Phoenix.PubSub`, Endpoint, LiveSocket.
- Variáveis de ambiente documentadas no `README.md` (placeholder; config real em 0.2.0).

### Módulo `Fenix.Constant`
- Paths S3: `manga_thumb_key/1`, `manga_chapter_key/3`, `profile_pic_key/1`.
- Roles, status, tipos de obra, enums em geral.
- Nenhuma string mágica no código (cumprir regra "no magic numbers" do AGENTS.md).

### Schemas Ecto
- `Usuario`, `Obra`, `Capitulo`, `Pagina`, `Genero`, `Autor`, `Artista`, `Permissao`, `Favorito`.
- `has_many`/`belongs_to`/`many_to_many` refletindo o DER.
- Mudanças: `Ecto.Enum` para `role`, `status`, `tipo`, `permissoes.tipo`.

### Contexts (esqueleto)
- `Fenix.Accounts` (apenas leitura/aggregates mínimos).
- `Fenix.Catalog`, `Fenix.Content` (somente estrutura).
- `Fenix.Storage` ainda não escrito — placeholder de módulo.

### Layouts e LiveView
- `FenixWeb.Layouts.app` recebendo `current_scope` e emitindo `<.flash_group>`.
- Header público com gradiente `#d1717c → #f0c382` aplicado.
- `<head>` base com `<title>`, `<meta charset>`, `<meta name="viewport">`.
- Componente `<.seo>` em `core_components.ex` (ou novo `FenixWeb.SEO`) que recebe `title`, `description`, `image`, `url` e emite `og:*`, `twitter:card`, `<link rel="canonical">`.
- Helper `FenixWeb.URIHelpers.full_url/2` para URLs absolutas.
- `live_session :public` e `live_session :authenticated` configurados (este último só consumindo `current_scope` no `on_mount`).

### Forms e CSRF
- Todos os forms via `<.form for={@form} ...>` (Phoenix gera o token CSRF automaticamente; nenhum código manual é necessário).
- `mix precommit` verde.

### Critérios de aceitação
- `mix ecto.migrate` aplica todas as migrations sem warnings.
- `iex -S mix` carrega o `Repo` e os schemas sem erros de compilação.
- Home temporária renderiza o gradiente do menu.
- `mix precommit` passa.

---

## 0.2.0 — Autenticação e `Fenix.Storage` (RustFS)

### `Fenix.Storage` (módulo central da integração S3)
- Config em `config/runtime.exs` lendo:
  - `RUSTFS_ENDPOINT`, `RUSTFS_BUCKET`, `RUSTFS_ACCESS_KEY`, `RUSTFS_SECRET_KEY`, `RUSTFS_REGION`.
- Cliente baseado em `Req` (biblioteca já presente, conforme AGENTS.md).
- Funções: `put_object/3`, `get_object/2`, `delete_object/2`, `presign_get/2`, `public_url/2`.
- Paths sempre via `Fenix.Constant` (nunca hardcoded).

### Autenticação
- Hash de senha (Bcrypt) — dependência adicionada em `mix.exs`.
- `Fenix.Accounts.register_user/2` com role padrão `:leitor` (RF03).
- `Fenix.Accounts.authenticate_user/2`, `get_user_by_email_and_password/2`.
- LiveView `UserAuth.Login` (modal `modal-fenix.png`) e `UserAuth.Registration`.
- `on_mount :assign_current_scope` para popular `@current_scope`.
- Pipeline `require_authenticated_user` para rotas privadas.
- Recuperação de senha **adiada** para 0.9.0.

### Foto de perfil (RF11) — primeiro uso do RustFS
- Upload no registro/edição: `usuarios/<id>/profile/profile.webp`.
- Validação de MIME e tamanho. Conversão para WebP no servidor antes do `put_object`.
- Página `/conta` para o usuário editar dados e foto.

### SEO
- Páginas de login/cadastro recebem `<meta name="robots" content="noindex">`.

### Critérios de aceitação
- Cadastro cria usuário com `role: :leitor`.
- Login persiste `current_scope` na sessão.
- Upload de foto de perfil grava em `usuarios/<id>/profile/profile.webp` no RustFS.
- `mix precommit` passa.

---

## 0.3.0 — Painel administrativo e CRUD de catálogo

### Painel admin (`admin-fenix.png`)
- LiveView `Admin.Dashboard` com cards:
  - Total Mangás, Total Novels, Gêneros, Autores, Artistas, Usuários.
- Abas: Mangás / Novels / Gêneros / Autores / Artistas / Usuários.
- Acesso restrito a `current_scope.user.role == :administrador`.

### CRUD `Obra`
- Criar/editar/excluir mangás e novels.
- Campos: título, ano, sinopse, status, flag `adulto`, tipo (manhwa/novel).
- Upload de thumbnail: `obras/<id>/capa.webp` (segundo uso do RustFS).
- Vincular `Genero`, `Autor`, `Artista` (N:N).
- Conversão automática para WebP ao receber JPG/PNG.

### CRUD de apoio
- `Genero`, `Autor`, `Artista`: criar/editar/excluir.

### Validações e erros
- Erros de FK (autor referenciado, etc.) tratados via `try/rescue` — `Ecto.Changeset.foreign_key_constraint/3` **não** funciona com SQLite3.
- Bulk inserts (`insert_all/3`) em transação `IMMEDIATE` para evitar `database is locked` ao cadastrar várias relações de uma vez.

### SEO
- Painel admin inteiro recebe `noindex`.

### Critérios de aceitação
- Admin consegue criar uma obra com capa, autor, artista e gêneros.
- Capa aparece no preview do painel e no card da home.
- `mix precommit` passa.

---

## 0.4.0 — Capítulos e páginas

### CRUD `Capitulo`
- Criar/editar/excluir capítulos vinculados a uma obra (RF07).
- Campos: número, título, thumbnail opcional.
- Geração automática de thumbnail do capítulo a partir da primeira página.

### Páginas de mangá (RF08, RF10, RF12)
- Upload de uma ou várias imagens `.webp`.
- Numeração zero-padded sequencial: `001.webp`, `002.webp`, etc.
- Caminho: `mangas/<obra_id>/capitulos/<capitulo_id>/NNN.webp`.
- Conversão automática para WebP se o usuário enviar JPG/PNG.
- Validação de MIME e tamanho máximo configurável em `Fenix.Constant`.

### Páginas de novel (RF12)
- Editor rich-text (Trix/Ecto) gravando em `paginas.conteudo_texto`.
- Cada "página" de novel é um bloco do capítulo (espécie de "paginador" textual).

### Página de detalhe da obra (`pagina-manga.png`)
- Capa, autor, artista, status, visualizações, gêneros, sinopse, rating placeholder.
- Lista de capítulos com badge "NOVO" para os 2 mais recentes.

### Leitor sequencial
- `/obras/:obra_id/capitulos/:capitulo_id` com navegação prev/next.
- `phx-update="stream"` na lista de páginas para evitar ballooning de memória.

### Critérios de aceitação
- Admin cria capítulo, faz upload de N webp e elas aparecem em ordem.
- Caminho S3 confere com a convenção `mangas/<obra_id>/capitulos/<cap_id>/NNN.webp`.
- `mix precommit` passa.

---

## 0.5.0 — Catálogo público e SEO completo

### Home (`home-page-fenix.png`)
- Header com gradiente, logo, navegação (`Início`, `Manhwas`, `Novels`, `Concluídos`), busca por título, botões `Entrar` / `Cadastrar` (quando deslogado).
- Seção **"Atualizados Recentemente"**: cards de obras com capa, título, dois últimos capítulos e badge "NOVO".
- Sidebar **"Os Mais Lidos"**: top 5 (dados preliminares; ETS real entra em 0.7.0).

### Listagens
- `/manhwas`, `/novels`, `/concluidos` com paginação e filtros por gênero.

### Detalhe da obra
- Tudo que está em `pagina-manga.png` + SEO completo abaixo.

### SEO (RNF06)
- `<.seo>` aplicado em:
  - Home → título do site, descrição, capa padrão.
  - `/manhwas`, `/novels` → título e descrição contextualizados.
  - `/obras/:id` → título da obra, sinopse como `description`, capa como `og:image`, URL canônica, JSON-LD `schema.org/Book` com `name`, `author`, `artist`, `genre`, `datePublished`.
  - `/obras/:id/capitulos/:cap_id` → `noindex` para evitar conteúdo duplicado.
- Páginas de autenticação e admin permanecem `noindex`.
- Componente `<.icon name="hero-...">` para todos os ícones (proibido usar módulos Heroicons diretamente).

### Critérios de aceitação
- Home renderiza conforme layout e responde em viewport mobile.
- JSON-LD validado em `https://search.google.com/test/rich-results`.
- `mix precommit` passa.

---

## 0.6.0 — Comentários em obras e capítulos (RF13, RF14)

### Migration
- `*_create_comentarios.exs`:
  - `id`, `usuario_id` (FK, NOT NULL, `on_delete: :delete_all`), `obra_id` (FK nullable, `on_delete: :delete_all`), `capitulo_id` (FK nullable, `on_delete: :delete_all`), `texto` (`string`, NOT NULL), `inserted_at`, `updated_at`.
  - **Check no nível de coluna** garantindo que exatamente um entre `obra_id` e `capitulo_id` é não-nulo (SQLite não tem polimórfico nativo; o check é a forma correta, conforme AGENTS.md).
  - Indexes: `(obra_id)`, `(capitulo_id)`, `(usuario_id)`.
  - Check em `texto`: `length(texto) > 0 AND length(texto) <= 2000`.

### Schema
- `Fenix.Content.Comentario` em `lib/fenix/content/comentario.ex`:
  - `belongs_to :usuario, Fenix.Accounts.Usuario`
  - `belongs_to :obra, Fenix.Catalog.Obra`
  - `belongs_to :capitulo, Fenix.Content.Capitulo`
  - `field :texto, :string`
  - `changeset/2`: `cast([:texto, :obra_id, :capitulo_id, :usuario_id])`; `validate_required([:usuario_id, :texto])`; `validate_length(:texto, min: 1, max: 2000)`; valida que exatamente um parent (`obra_id` xor `capitulo_id`) está setado.
  - Note: `usuario_id` é setado **programaticamente** (a partir de `@current_scope.user.id`), portanto **não** entra em `cast` na criação (regra do AGENTS.md).

### Context
- `Fenix.Content` ganha:
  - `list_comentarios_for_obra/1` (preload `:usuario`).
  - `list_comentarios_for_capitulo/1` (preload `:usuario`).
  - `create_comentario/2` (current_user, attrs com `obra_id` ou `capitulo_id`).
  - `update_comentario/3` (current_user, comentario, attrs) — só o autor.
  - `delete_comentario/2` (current_user, comentario) — autor ou `role == :administrador`.

### LiveSession `:authenticated`
- A stub de 0.1.0 vira real: `on_mount: [{FenixWeb.UserAuth, :assign_current_scope}]`.
- `FenixWeb.UserAuth` (de 0.1.0/0.2.0) implementa o `current_scope/1` real.
- O form de comentário só renderiza se `@current_scope.user` está presente.

### UI
- Em `/obras/:id` (página da obra) — seção **"Comentários"** (RF13):
  - Form `<.form for={@comentario_form} id="obra-#{@obra.id}-comentario-form" phx-submit="criar_comentario_obra">` com `<textarea>` + botão `Comentar` — visível só para usuários logados.
  - Lista de comentários com `avatar + nome + data relativa + texto + botão Deletar` (visível só para autor ou admin).
  - Visitante anônimo vê a lista + prompt `Faça login para comentar`.
- Em `/obras/:id/capitulos/:cap_id` (leitor) — seção **"Comentários do capítulo"** (RF14): idem, evento `phx-submit="criar_comentario_capitulo"`.
- Streams do LiveView (`stream(socket, :comentarios_obra, ...)`) para evitar ballooning.
- Otimistic UI: comentário aparece imediatamente após submit, antes da confirmação do servidor.

### CSRF
- Todos os forms via `<.form for={@comentario_form} ...>` (Phoenix injeta o token automaticamente).
- Verificação de aceitação: inspecionar HTML do form em dev deve mostrar `name="_csrf_token"`.

### SEO
- Obra e capítulo continuam indexáveis (RNF06); o `current_scope` não vaza para o SSR.
- Lista de comentários é carregada via LiveView patch — não vai no HTML inicial do SSR, evitando conteúdo duplicado/spam indexado.
- Se for criada uma rota dedicada `/obras/:id/comentarios` no futuro, ela recebe `<meta name="robots" content="noindex">` por padrão (RNF06).

### Critérios de aceitação
- `mix ecto.migrate` cria `comentarios` com check constraint ativo.
- Usuário `leitor` logado consegue postar comentário em obra e em capítulo.
- Comentário aparece na lista imediatamente (LiveView stream).
- Autor do comentário vê botão `Deletar` e consegue remover.
- `administrador` consegue deletar qualquer comentário.
- Visitante anônimo vê os comentários existentes mas o form não é renderizado.
- Token CSRF presente em todos os POSTs (verificar via `<.form>`).
- `mix precommit` limpo.

---

## 0.7.0 — ETS table para contabilização

### Por que ETS (e não DB direto)
- Cada abertura de capítulo é uma escrita. Gravar no SQLite3 a cada visita cria contenção (limite de uma escrita por vez).
- ETS permite incrementar em memória e fazer flush periódico em uma única transação `IMMEDIATE`.

### Implementação
- Tabela ETS `:obra_views` (chave: `obra_id`, valor: contador). Iniciada no `Fenix.Application` via `Fenix.Views.Counter` (GenServer).
- Ao renderizar o capítulo (`handle_event` ou `mount` do LiveView), incrementa via `ets:update_counter/3` (RF06).
- `Fenix.Views.Counter` faz flush para `obras.visualizacoes` a cada `n` minutos (constante em `Fenix.Constant`).
- Snapshot inicial a partir do banco ao subir a aplicação.
- Recuperação em caso de restart: flush final no `terminate/2`.

### Top 10 mais lidos (RF05)
- LiveView reutiliza a tabela ETS via `ets:tab2list/1` + `Enum.sort/2` com `n` configurável.
- Exibido na sidebar da home (até 10 para mangas, até 10 para novels).

### Critérios de aceitação
- Acessos são contabilizados em memória.
- Flush periódico atualiza `obras.visualizacoes`.
- Restart da aplicação não perde o snapshot.
- `mix precommit` passa.

---

## 0.8.0 — Favoritos

### Backend
- `Fenix.Catalog.favorite/2`, `unfavorite/2`, `favorited?/2`, `list_user_favorites/1`.
- Constraint única `[usuario_id, obra_id]` (RF04).
- Eventos LiveView `favorite` / `unfavorite` otimistas (UI atualiza antes do round-trip).

### UI
- Botão de favoritar (ícone de estrela) na home e na página da obra.
- Página `/favoritos` listando as obras favoritadas pelo usuário logado.

### Home atualizada
- "Os Mais Lidos" agora consulta ETS em tempo real (já estava em 0.7.0, aqui ganha polimento visual).

### Critérios de aceitação
- Usuário logado favorita e desfavorita; estado persiste entre sessões.
- `mix precommit` passa.

---

## 0.9.0 — Editor e permissões por obra

### Modelo `Permissao` (RF02)
- Tabela `permissoes` (já existente desde 0.1.0) entra em uso.
- Admin concede/revoga `tipo: :editor` para um usuário em uma obra específica.

### Papel `editor` (RNF02)
- Editor vê no painel apenas as obras em que possui permissão.
- Editor pode criar/editar capítulos e páginas das suas obras.
- Editor **não** pode excluir a obra nem conceder permissões.

### UI
- Painel admin: nova aba "Permissões" para conceder/revogar.
- Tela da obra: seção "Editores" para o admin vincular usuários.

### Recuperação de senha (adiada de 0.2.0)
- Token em memória no `Fenix.Accounts`, e-mail simulado via `Swoosh` (já presente em `mix.exs`).

### Critérios de aceitação
- Admin concede permissão; editor passa a ver a obra no painel.
- Editor não vê obras sem permissão.
- `mix precommit` passa.

---

## 0.10.0 — Upload-atalho de capítulos (síncrono)

### Tela de upload (`Admin.Obra.UploadZip`)
- Botão "Adicionar capítulos" no detalhe da obra abre modal.
- Campos:
  - Mangá (pré-selecionado se acessado a partir de uma obra).
  - Input de arquivo `.zip`.
  - Política de colisão (radio): `pular`, `substituir`, `abortar`.

### Regras de parsing (detalhadas)
1. **Top-level folders = capítulos.** Cada subdiretório na raiz do ZIP representa um capítulo.
2. **Nome do subdiretório = número do capítulo.** O parser tenta `Integer.parse/1`:
   - Se bem-sucedido, esse é o `capitulo.numero`.
   - Se falhar, gera-se `capitulo_<slug>` derivado do nome da pasta.
3. **Arquivos dentro da pasta = páginas.** Apenas extensões `.webp` (case-insensitive) são aceitas; demais extensões causam erro com mensagem clara.
4. **Ordenação e numeração:** os arquivos `.webp` são ordenados lexicograficamente e renumerados como `001.webp`, `002.webp`, ... no storage. A ordem original é preservada independente do nome original do arquivo.
5. **Arquivos soltos na raiz do ZIP** (fora de qualquer pasta) são rejeitados com erro explicando a estrutura esperada.
6. **Capítulos sem páginas válidas** são pulados e reportados ao usuário no resultado final.
7. **Colisão de número:** se já existir um capítulo com aquele número na obra, aplica-se a política escolhida (`pular` / `substituir` / `abortar`). Em `substituir`, as páginas antigas são deletadas do RustFS antes de gravar as novas.

### Implementação síncrona
- `Fenix.Storage.upload_zip/3`:
  - Recebe `%Plug.Upload{}` ou `Path.t()`.
  - Stream de entrada via `Stream.unzip/2` ou `Zip.stream_entries/2`.
  - Para cada arquivo: converte (se preciso) para WebP, faz `put_object/3` em `mangas/<obra_id>/capitulos/<cap_id>/NNN.webp`.
  - Persiste registros com `Multi` em transação `IMMEDIATE` por capítulo.
- Constantes de path em `Fenix.Constant` — zero hardcode.
- Feedback final ao usuário: lista de capítulos criados, pulados e erros.

### Critérios de aceitação
- ZIP com `1/001.webp ... 1/099.webp` cria o capítulo 1 com 99 páginas na ordem correta.
- ZIP com `1/`, `2/` cria dois capítulos.
- Política de colisão funciona em todos os três modos.
- `mix precommit` passa.

---

## 1.0.0 — Oban para upload assíncrono e polimento

### Oban
- Adicionar dependência `:oban` ao `mix.exs`.
- Migration `oban_jobs` (gerada por `mix oban.install`).
- Worker `Fenix.Workers.ZipUploadWorker`:
  - Argumentos: `obra_id`, `zip_path`, `politica_colisao`, `usuario_id`.
  - Reaproveita `Fenix.Storage.upload_zip/3` internamente.
  - Cada capítulo é uma suboperação, com retry individual em caso de falha transitória.
  - Cleanup do arquivo temporário no `perform/1` e em `on_failure/1`.
- Fila dedicada `queue: :uploads` com concorrência configurada em `Fenix.Constant`.

### UX
- LiveView faz subscribe no `Phoenix.PubSub` para progresso por capítulo.
- Exibição por etapa: upload → extração → upload S3 → registro no DB → OK/erro.
- Botão "Reenviar" para capítulos que falharam.

### Oban no restante do app
- Auditoria assíncrona de acessos pode aproveitar o Oban (opcional, se ajudar a aliviar ainda mais o SQLite3).
- Relatórios top 10 mais lidos podem ser pré-computados em job noturno (opcional).

### SEO e polimento final
- Geração de `sitemap.xml` dinâmico (obras atualizadas + gêneros + páginas estáticas).
- `robots.txt` servido de `priv/static`.
- Lighthouse SEO ≥ 90, Best Practices ≥ 90, Performance ≥ 80 (RNF03, RNF05).
- Revisão de acessibilidade: contraste, foco visível, ARIA quando necessário.

### Checklist final contra `001-requisitos.md`

| Req | Versão que o atende |
|---|---|
| RF01 (admin gerencia tudo) | 0.3.0 + 0.9.0 |
| RF02 (editor gerencia suas obras) | 0.9.0 |
| RF03 (cadastro padrão `leitor`) | 0.2.0 |
| RF04 (favoritar) | 0.8.0 |
| RF05 (top 10 mais lidos) | 0.7.0 |
| RF06 (contabilização de acessos) | 0.7.0 |
| RF07 (capítulos ↔ obra) | 0.4.0 |
| RF08 (páginas ↔ capítulo) | 0.4.0 |
| RF09 (autores/gêneros/artistas ↔ obra) | 0.3.0 |
| RF10 (webp em capítulos de mangá) | 0.4.0 |
| RF11 (foto de perfil) | 0.2.0 |
| RF12 (páginas ordenadas / rich-text) | 0.4.0 |
| RF13 (comentários em obras) | 0.6.0 |
| RF14 (comentários em capítulos) | 0.6.0 |
| RNF01 (web) | base |
| RNF02 (papéis) | 0.2.0 + 0.9.0 |
| RNF03 (usabilidade) | todas |
| RNF04 (responsivo) | todas |
| RNF05 (performance) | 0.7.0 (ETS) + 1.0.0 (Oban) |
| RNF06 (SEO) | 0.5.0 (base) + 1.0.0 (sitemap) |

### Critérios de aceitação finais
- `mix precommit` limpo.
- `mix test` (apenas os já existentes — sem geração de novos testes, conforme AGENTS.md).
- Walkthrough manual cobrindo todos os RFs/RNFs.
- `sitemap.xml` e `robots.txt` válidos.
- ZIP de 200+ páginas processado via Oban sem timeout no request HTTP.

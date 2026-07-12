alias Fenix.{Repo, Catalog.Genero}

generos = [
  "Ação",
  "Aventura",
  "Comédia",
  "Drama",
  "Fantasia",
  "Horror",
  "Romance",
  "Sci-Fi",
  "Slice of Life",
  "Sobrenatural",
  "Mistério",
  "Esportes",
  "Psicológico",
  "Isekai",
  "Murim",
  "Harem",
  "Ecchi",
  "Seinen",
  "Shounen",
  "Josei",
  "Mecânica",
  "Magia",
  "Cultivo",
  "Regressão",
  "Sistema"
]

for nome <- generos do
  %Genero{}
  |> Genero.changeset(%{nome: nome})
  |> Repo.insert!(on_conflict: :nothing, conflict_target: :nome)
end

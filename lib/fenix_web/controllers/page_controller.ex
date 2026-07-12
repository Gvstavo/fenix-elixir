defmodule FenixWeb.PageController do
  use FenixWeb, :controller

  def home(conn, _params) do
    current_scope = FenixWeb.UserAuth.current_scope(conn)

    conn
    |> assign(:page_title, "Início")
    |> assign(:meta_description, "Plataforma de leitura de manhwas e novels")
    |> assign(:current_scope, current_scope)
    |> render(:home)
  end
end

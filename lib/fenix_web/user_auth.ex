defmodule FenixWeb.UserAuth do
  @moduledoc """
  Stub de autenticação. Implementação real entra em 0.2.0.

  Em 0.1.0 todas as funções retornam `nil` ou são no-ops, para que o
  esqueleto de `current_scope` e `on_mount :assign_current_scope` já
  esteja no lugar e o código das próximas versões encaixe sem refactor.
  """

  @doc """
  Retorna o `current_scope` para a sessão/conexão.

  Em 0.1.0 sempre retorna `nil` (sem auth). Em 0.2.0 lê o `user_token`
  da sessão, busca o usuário e devolve `%{user: usuario}`.
  """
  def current_scope(_conn_or_socket), do: nil

  @doc """
  Callback `on_mount` para LiveViews autenticados.

  No-op em 0.1.0. Em 0.2.0 atribui `@current_scope` ao socket a partir
  da sessão.
  """
  def on_mount(:assign_current_scope, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(_event, _params, _session, socket) do
    {:cont, socket}
  end

  @doc """
  Versão `on_mount` para LiveViews que exigem usuário logado.
  Em 0.1.0 apenas no-op. Em 0.2.0 redireciona para `/entrar`.
  """
  def require_authenticated(_conn_or_socket, _opts \\ []) do
    raise "FenixWeb.UserAuth.require_authenticated/2 entra em 0.2.0"
  end

  @doc """
  Login do usuário. Stub — implementação real em 0.2.0.
  """
  def log_in_user(_conn, _usuario, _params \\ %{}) do
    raise "FenixWeb.UserAuth.log_in_user/3 entra em 0.2.0"
  end

  @doc """
  Logout do usuário. Stub — implementação real em 0.2.0.
  """
  def log_out_user(_conn_or_socket) do
    raise "FenixWeb.UserAuth.log_out_user/1 entra em 0.2.0"
  end

  @doc """
  Busca o usuário pelo `user_token` da sessão. Stub.
  """
  def fetch_current_usuario(_token), do: nil
end

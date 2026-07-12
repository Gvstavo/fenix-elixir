defmodule FenixWeb.Router do
  use FenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FenixWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  live_session :public, on_mount: [{FenixWeb.UserAuth, :assign_current_scope}] do
    scope "/", FenixWeb do
    end
  end

  live_session :authenticated, on_mount: [{FenixWeb.UserAuth, :assign_current_scope}] do
    scope "/", FenixWeb do
    end
  end

  if Application.compile_env(:fenix, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

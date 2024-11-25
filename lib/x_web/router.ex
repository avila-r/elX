defmodule XWeb.Router do
  use XWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
  end

  scope "/api", XWeb do
    pipe_through :api

    scope "/v1" do
      scope "/" do
        pipe_through :auth

        resources "/users", UsersController,
          only: [
            :index,
            :show,
            :update,
            :delete
          ]
      end
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:x, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: XWeb.Telemetry
    end
  end
end

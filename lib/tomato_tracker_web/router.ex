defmodule TomatoTrackerWeb.Router do
  use TomatoTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TomatoTrackerWeb do
    pipe_through :browser # Use the default browser stack

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", TomatoController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TomatoTrackerWeb do
  #   pipe_through :api
  # end
end

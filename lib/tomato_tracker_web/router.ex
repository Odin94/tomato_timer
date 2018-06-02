defmodule TomatoTrackerWeb.Router do
  use TomatoTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker  # used for redirecting back to origin of request
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TomatoTrackerWeb do
    pipe_through :browser # Use the default browser stack

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", ProjectController)
  end

  scope "/tomato", TomatoTrackerWeb do
    pipe_through :browser # Use the default browser stack

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", TomatoController)
  end

  scope "/task", TomatoTrackerWeb do
    pipe_through :browser # Use the default browser stack

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", TaskController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TomatoTrackerWeb do
  #   pipe_through :api
  # end
end

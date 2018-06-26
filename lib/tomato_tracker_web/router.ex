defmodule TomatoTrackerWeb.Router do
  use TomatoTrackerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    # used for redirecting back to origin of request
    plug(NavigationHistory.Tracker)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TomatoTrackerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", ProjectController)
  end

  scope "/tomato", TomatoTrackerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", TomatoController)
  end

  scope "/task", TomatoTrackerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # automatically creates REST routes, only works if you follow RESTful conventions (/new -> new() etc.)
    resources("/", TaskController)
  end

  scope "/quota_tracker", TomatoTrackerWeb do
    pipe_through(:browser)

    put("/update", QuotaTrackerController, :update)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TomatoTrackerWeb do
  #   pipe_through :api
  # end
end

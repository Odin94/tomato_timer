defmodule TomatoTrackerWeb.PageController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

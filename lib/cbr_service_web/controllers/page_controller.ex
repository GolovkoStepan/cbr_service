defmodule CbrServiceWeb.PageController do
  use CbrServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

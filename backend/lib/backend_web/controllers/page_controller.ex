defmodule BackendWeb.PageController do
  use BackendWeb, :controller

  alias ArkeServer.ResponseManager

  def home(conn, _params) do

    ResponseManager.send_resp(conn, 200, nil)
  end
end

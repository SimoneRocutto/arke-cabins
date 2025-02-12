defmodule Backend.Arke.Cabin do
  use Arke.System

  arke id: :cabin do
  end

  # def create(arke) do
  #   Arke.QueryManager.create()
  #   {:ok, %{}, 200}
  # end

  def create(%Plug.Conn{body_params: params} = conn, %{"arke_id" => id}) do
    # all arkes struct and gen server are on :arke_system so it won't be changed to project
    project = conn.assigns[:arke_project]
    params = Map.put(params, "runtime_data", %{conn: conn})
    arke = ArkeManager.get(String.to_atom(id), project)

    # TODO handle query parameter with plugs
    load_links = Map.get(conn.query_params, "load_links", "false") == "true"
    load_values = Map.get(conn.query_params, "load_values", "false") == "true"
    load_files = Map.get(conn.query_params, "load_files", "false") == "true"

    QueryManager.create(project, arke, ArkeServer.ArkeController.data_as_klist(params))
    |> case do
      {:ok, unit} ->
        ResponseManager.send_resp(conn, 200, %{
          content:
            StructManager.encode(unit,
              load_links: load_links,
              load_values: load_values,
              load_files: load_files,
              type: :json
            )
        })

      {:error, error} ->
        ResponseManager.send_resp(conn, 400, nil, error)
    end
  end

end

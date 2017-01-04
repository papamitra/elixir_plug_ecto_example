defmodule Router do
  defmacro __using__(_opts) do
    quote do
      def init(options) do
        options
      end
      def call(conn, _opts) do
        route(conn.method, conn.path_info, conn)
      end
    end
  end
end


defmodule UserRouter do
  use Router
  def route("GET", ["users", user_id], conn) do
    conn |> Plug.Conn.send_resp(200, "You reuquested user #{user_id}")
  end
  def route("POST", ["users"], conn) do
    # do some sort of database insertion here maybe
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "Couldn't find that page, sorry!")
  end

end

defmodule WebsiteRouter do
  use Router
  @user_router_options UserRouter.init([])
  def route("GET", ["users" | path], conn) do
    UserRouter.call(conn, @user_router_options)
  end

  def route(_method, _path, conn) do
    conn |> Plug.Conn.send_resp(404, "Couldn't find that page, sorry!")
  end

end

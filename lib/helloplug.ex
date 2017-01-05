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
    case Helloplug.Repo.get(User, user_id) do
      nil ->
        conn |> Plug.Conn.send_resp(404, "User with that ID not found, sorry")
      user ->
        page_contents = EEx.eval_file("templates/show_user.eex", [user: user])
        conn |> Plug.Conn.put_resp_content_type("text/html") |> Plug.Conn.send_resp(200, page_contents)     end
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

defmodule Helloplug.Repo do
  use Ecto.Repo,
  otp_app: :helloplug,
  adapter: Sqlite.Ecto
end

defmodule User do
  use Ecto.Model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    timestamps
  end

end

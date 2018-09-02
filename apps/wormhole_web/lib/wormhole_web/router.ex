defmodule WormholeWeb.Router do
  use WormholeWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", WormholeWeb do
    pipe_through(:api)
  end
end

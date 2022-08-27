defmodule Ethertransact.Repo do
  use Ecto.Repo,
    otp_app: :ethertransact,
    adapter: Ecto.Adapters.Postgres
end

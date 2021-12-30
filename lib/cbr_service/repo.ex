defmodule CbrService.Repo do
  use Ecto.Repo,
    otp_app: :cbr_service,
    adapter: Ecto.Adapters.Postgres
end

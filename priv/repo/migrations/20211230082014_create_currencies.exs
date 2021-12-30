defmodule CbrService.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :num_code, :integer
      add :char_code, :string
      add :nominal, :integer
      add :name, :string
      add :rate, :float

      timestamps()
    end
  end
end

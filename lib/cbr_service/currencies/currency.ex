defmodule CbrService.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :char_code, :string
    field :name, :string
    field :nominal, :integer
    field :num_code, :integer
    field :rate, :float

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:num_code, :char_code, :nominal, :name, :rate])
    |> validate_required([:num_code, :char_code, :nominal, :name, :rate])
    |> unique_constraint([:num_code, :char_code, :name])
  end
end

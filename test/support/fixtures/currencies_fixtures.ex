defmodule CbrService.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CbrService.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    {:ok, currency} =
      attrs
      |> Enum.into(%{
        char_code: "some char_code",
        name: "some name",
        nominal: 42,
        num_code: 42,
        rate: 120.5
      })
      |> CbrService.Currencies.create_currency()

    currency
  end
end

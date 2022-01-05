defmodule CbrService.CurrenciesTest do
  use CbrService.DataCase

  alias CbrService.Currencies

  describe "currencies" do
    alias CbrService.Currencies.Currency

    import CbrService.CurrenciesFixtures

    @invalid_attrs %{char_code: nil, name: nil, nominal: nil, num_code: nil, rate: nil}

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Currencies.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Currencies.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      valid_attrs = %{
        char_code: "some char_code",
        name: "some name",
        nominal: 42,
        num_code: 42,
        rate: 120.5
      }

      assert {:ok, %Currency{} = currency} = Currencies.create_currency(valid_attrs)
      assert currency.char_code == "some char_code"
      assert currency.name == "some name"
      assert currency.nominal == 42
      assert currency.num_code == 42
      assert currency.rate == 120.5
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Currencies.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()

      update_attrs = %{
        char_code: "some updated char_code",
        name: "some updated name",
        nominal: 43,
        num_code: 43,
        rate: 456.7
      }

      assert {:ok, %Currency{} = currency} = Currencies.update_currency(currency, update_attrs)
      assert currency.char_code == "some updated char_code"
      assert currency.name == "some updated name"
      assert currency.nominal == 43
      assert currency.num_code == 43
      assert currency.rate == 456.7
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Currencies.update_currency(currency, @invalid_attrs)
      assert currency == Currencies.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Currencies.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Currencies.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Currencies.change_currency(currency)
    end

    test "update_all_currencies/1 updates rates" do
      currency = currency_fixture()
      Currencies.update_all_currencies([%{num_code: currency.num_code, rate: 123.45}])
      updated_currency = Currencies.get_by_num_code(currency.num_code)

      assert updated_currency.rate == 123.45
    end
  end
end

defmodule CbrServiceWeb.CurrencyLiveTest do
  use CbrServiceWeb.ConnCase

  import Phoenix.LiveViewTest
  import CbrService.CurrenciesFixtures

  alias CbrService.Currencies

  defp create_currency(_) do
    currency = currency_fixture()
    %{currency: currency}
  end

  describe "Index" do
    setup [:create_currency, :register_and_log_in_user]

    test "lists all currencies", %{conn: conn, currency: currency} do
      {:ok, _index_live, html} = live(conn, Routes.currency_index_path(conn, :index))

      assert html =~ "Курс: #{currency.rate}"
    end

    test "update rates handle info", %{conn: conn, currency: currency} do
      {:ok, view, html} = live(conn, Routes.currency_index_path(conn, :index))

      assert html =~ "Обновить курсы валют"
      assert html =~ "Курс: #{currency.rate}"

      {:ok, _} = Currencies.update_currency(currency, %{rate: 999.99})

      send(view.pid, {:updated, :all})
      assert render(view) =~ "999.99"
    end
  end

  describe "Show" do
    setup [:create_currency, :register_and_log_in_user]

    test "displays currency", %{conn: conn, currency: currency} do
      {:ok, _show_live, html} = live(conn, Routes.currency_show_path(conn, :show, currency))

      assert html =~ currency.char_code
    end

    test "update rates handle info", %{conn: conn, currency: currency} do
      {:ok, view, html} = live(conn, Routes.currency_show_path(conn, :show, currency))

      assert html =~ "Обновить курсы валют"
      assert html =~ "#{currency.rate}"
      assert html =~ "#{currency.nominal}"

      {:ok, updated_currency} =
        Currencies.update_currency(currency, %{rate: 999.99, nominal: 123})

      send(view.pid, {:updated, updated_currency})
      html = render(view)

      assert html =~ "999.99"
      assert html =~ "123"
    end
  end
end

defmodule CbrServiceWeb.CurrencyLiveTest do
  use CbrServiceWeb.ConnCase

  import Phoenix.LiveViewTest
  import CbrService.CurrenciesFixtures

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
  end

  describe "Show" do
    setup [:create_currency, :register_and_log_in_user]

    test "displays currency", %{conn: conn, currency: currency} do
      {:ok, _show_live, html} = live(conn, Routes.currency_show_path(conn, :show, currency))

      assert html =~ currency.char_code
    end
  end
end

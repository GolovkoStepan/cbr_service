defmodule CbrServiceWeb.CurrencyLive.Index do
  use CbrServiceWeb, :live_view

  alias CbrService.Currencies
  alias CbrService.CurrenciesParser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :currencies, list_currencies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket), do: Currencies.subscribe()
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("update_rates", _params, socket) do
    Task.async(fn ->
      CurrenciesParser.fetch() |> Currencies.update_all_currencies()
    end)

    {:noreply, put_flash(socket, :info, "Обновление запущено")}
  end

  @impl true
  def handle_info({:updated, :all}, socket) do
    {:noreply, assign(socket, :currencies, list_currencies())}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Currencies")
    |> assign(:currency, nil)
  end

  defp list_currencies do
    Currencies.list_currencies()
  end
end

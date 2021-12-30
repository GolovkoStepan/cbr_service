defmodule CbrServiceWeb.CurrencyLive.Index do
  use CbrServiceWeb, :live_view

  alias CbrService.Currencies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :currencies, list_currencies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

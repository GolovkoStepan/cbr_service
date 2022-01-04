defmodule CbrServiceWeb.CurrencyLive.Show do
  use CbrServiceWeb, :live_view

  alias CbrService.Currencies
  alias CbrService.CurrenciesParser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Currencies.subscribe(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:currency, Currencies.get_currency!(id))}
  end

  @impl true
  def handle_event("update_rates", _params, socket) do
    Task.async(fn ->
      CurrenciesParser.fetch() |> Currencies.update_all_currencies()
    end)

    {:noreply, put_flash(socket, :info, "Обновление запущено")}
  end

  @impl true
  def handle_info({:updated, currency}, socket) do
    IO.inspect socket
    {:noreply, update(socket, :currency, fn _ -> currency end)}
  end

  defp page_title(:show), do: "Show Currency"
end

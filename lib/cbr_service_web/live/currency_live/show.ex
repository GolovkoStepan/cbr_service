defmodule CbrServiceWeb.CurrencyLive.Show do
  use CbrServiceWeb, :live_view

  alias CbrService.Accounts
  alias CbrService.Currencies
  alias CbrService.CurrenciesParser

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok, assign(socket, current_user: Accounts.get_user_by_session_token(token))}
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
    {:noreply, update(socket, :currency, fn _ -> currency end)}
  end

  defp page_title(:show), do: "Show Currency"
end

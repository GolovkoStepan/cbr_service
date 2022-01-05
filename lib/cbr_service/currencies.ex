defmodule CbrService.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias CbrService.Repo

  alias CbrService.Currencies.Currency

  @doc """
  Returns the list of currencies.

  ## Examples

      iex> list_currencies()
      [%Currency{}, ...]

  """
  def list_currencies do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!(123)
      %Currency{}

      iex> get_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency!(id), do: Repo.get!(Currency, id)

  @doc """
  Gets a single currency by num code.

  ## Examples

      iex> get_by_num_code(233)
      %Currency{}

  """
  def get_by_num_code(num_code), do: Repo.get_by(Currency, num_code: num_code)

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a currency.

  ## Examples

      iex> update_currency(currency, %{field: new_value})
      {:ok, %Currency{}}

      iex> update_currency(currency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
    |> broadcast(:updated)
  end

  @doc """
  Updates all currencies by array of maps.

  ## Examples

      iex> update_all_currencies([])

  """
  def update_all_currencies(arr) do
    Enum.each(arr, fn record ->
      get_by_num_code(record.num_code)
      |> update_currency(%{rate: record.rate})
    end)

    broadcast(:all, :updated)
  end

  @doc """
  Deletes a currency.

  ## Examples

      iex> delete_currency(currency)
      {:ok, %Currency{}}

      iex> delete_currency(currency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency changes.

  ## Examples

      iex> change_currency(currency)
      %Ecto.Changeset{data: %Currency{}}

  """
  def change_currency(%Currency{} = currency, attrs \\ %{}) do
    Currency.changeset(currency, attrs)
  end

  @spec subscribe :: :ok | {:error, {:already_registered, pid}}
  def subscribe do
    Phoenix.PubSub.subscribe(CbrService.PubSub, "currencies")
  end

  @spec subscribe(any) :: :ok | {:error, {:already_registered, pid}}
  def subscribe(id) do
    Phoenix.PubSub.subscribe(CbrService.PubSub, "currency-#{id}")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast(:all, event) do
    Phoenix.PubSub.broadcast(CbrService.PubSub, "currencies", {event, :all})
    :ok
  end

  defp broadcast({:ok, currency}, event) do
    Phoenix.PubSub.broadcast(CbrService.PubSub, "currency-#{currency.id}", {event, currency})
    {:ok, currency}
  end
end

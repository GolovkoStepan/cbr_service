defmodule CbrService.CurrenciesParser do
  def fetch do
    fetch_xml()
    |> convert_to_map()
    |> remap()
  end

  defp fetch_xml do
    url = Application.get_env(:cbr_service, __MODULE__)[:url]
    response = HTTPoison.get!(url)
    Codepagex.to_string(response.body, :"VENDORS/MICSFT/WINDOWS/CP1251")
  end

  defp convert_to_map({:ok, str}) do
    str
    |> String.replace(~r/windows-1251/, "utf-8")
    |> XmlToMap.naive_map()
  end

  defp remap(map) do
    map["ValCurs"]["#content"]["Valute"]
    |> Enum.map(fn record ->
      content = record["#content"]

      %{
        char_code: content["CharCode"],
        num_code: String.to_integer(content["NumCode"]),
        name: content["Name"],
        nominal: String.to_integer(content["Nominal"]),
        rate: String.to_float(content["Value"])
      }
    end)
  end
end

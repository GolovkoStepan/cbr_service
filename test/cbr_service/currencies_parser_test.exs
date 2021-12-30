defmodule CbrService.CurrenciesParserTest do
  use ExUnit.Case, async: false

  import Mock

  alias CbrService.CurrenciesParser

  @file_path Path.expand("../support/fixtures/files/xml_example.xml", __DIR__)
  @expected_result [
    %{char_code: "A", name: "A currency", nominal: 1, num_code: 1, rate: 12.34},
    %{char_code: "B", name: "B currency", nominal: 1, num_code: 2, rate: 56.78}
  ]

  describe "fetch/0" do
    test "should get xml from cbr.ru and convert it to map" do
      {:ok, content} = File.read(@file_path)

      with_mock HTTPoison, [get!: fn(_url) -> %{body: content} end] do
        assert @expected_result = CurrenciesParser.fetch()
      end
    end
  end
end

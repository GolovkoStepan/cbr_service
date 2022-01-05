# Drop all currencies from database
CbrService.Repo.delete_all(CbrService.Currencies.Currency)
# Load currencies data from cbr.ru to database
CbrService.CurrenciesParser.fetch()
|> Enum.each(fn(dataset) -> CbrService.Currencies.create_currency(dataset) end)

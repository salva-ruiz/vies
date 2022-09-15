# Vies

A utility to query the European SOAP VIES web service using the https://ec.europa.eu/taxation_customs/vies/services/checkVatService.wsdl XML schema. You can check https://ec.europa.eu/taxation_customs/vies/#/faq (Q18) for more information.

## Install the dependencies

```
mix deps.get
```

## Example

Starts IEx with `iex -S mix`

```elixir
Vies.is_valid?("ES10X")
# {:ok, false}

Vies.check_vat_numbers(["ES10X", "ES99999999X"])
# [{"ES10X", false}, {"ES99999999X", false}]
```

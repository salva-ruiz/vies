# Vies

A utility to query the European SOAP VIES web service

## Install the dependencies

```
mix deps.get
```

## Example

Starts IEx with `iex -S mix`

```elixir
Vies.is_valid?("ES10X")
# false

Vies.check_vat_numbers(["ES10X", "ES99999999X"])
# [{"ES10X", false}, {"ES99999999X", false}]
```

defmodule Vies do
  import SweetXml

  @endpoint "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"

  @moduledoc """
  Utility for query the european VIES SOAP web service.
  Check https://ec.europa.eu/taxation_customs/vies for more information.
  """

  @doc """
  Check the validate of a list of VAT numbers.

  ## Examples

      iex> Vies.check_vat_numbers(["ES10X", "ES99999999X", "ES15S"])
      [{"ES10X", false}, {"ES99999999X", true}, {"ES15S", nil}]
  """
  def check_vat_numbers(vat_numbers) do
    for vat <- vat_numbers do
      case is_valid?(vat) do
        {:ok, result} -> {vat, result}
        _ -> {vat, nil}
      end
    end
  end

  @doc """
  Check if a VAT number is valid.

  ## Examples

      iex> Vies.is_valid?("ES99999999X")
      {:ok, false}

      iex> Vies.is_valid?("ES10X")
      {:error, "Could not get a response"}
  """
  def is_valid?(vat_number) do
    request = """
      <soapenv:Envelope
      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
        <soapenv:Header/>
        <soapenv:Body>
          <urn:checkVat>
            <urn:countryCode>#{String.slice(vat_number, 0..1)}</urn:countryCode>
            <urn:vatNumber>#{String.slice(vat_number, 2..-1)}</urn:vatNumber>
          </urn:checkVat>
        </soapenv:Body>
      </soapenv:Envelope>
    """

    headers = [
      {"Content-Type", "text/xml; charset=UTF-8"},
      {"Accept", "text/xml"}
    ]

    with {:ok, %{status_code: 200, body: xml}} <- HTTPoison.post(@endpoint, request, headers),
         valid <- xpath(xml, ~x"//ns2:valid/text()"),
         false <- is_nil(valid) do
      {:ok, valid == 'true'}
    else
      _ -> {:error, "Could not get a response"}
    end
  end
end

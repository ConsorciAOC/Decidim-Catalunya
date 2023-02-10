# frozen_string_literal: true

require "base64"

#
# Parses a response from the Via Oberta WS.
#
class ViaObertaAuthorizationRs
  # raw_response: The response as a String
  def initialize(raw_response)
    @raw = raw_response
  end

  def rs_inside_soap
    @rs_inside_soap ||= parse_response(@raw)
  end

  def active?
    rs_inside_soap.xpath("//codigoResultado").text == "1"
  end

  private

  def parse_response(response)
    # The *real* response data is encoded as a xml string inside a xml node.
    parsed = Nokogiri::XML(response.body).remove_namespaces!
    parsed.xpath("//respuestaResidenteMunicipio")[0]
  end

  # Decode a date from an API timestamp format
  def decode_date(date)
    Date.strptime(date, "%Y%m%d%H%M%S")
  end
end

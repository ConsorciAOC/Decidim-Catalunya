# frozen_string_literal: true

require "digest"
require "faraday"
require "base64"

#
# Performs a request to the Via Oberta WS to VALIDATE a person by document and birth date.
#
# To send a request you MUST provide:
# - document_type:
# - id_document: A String with the identify document
#
class ViaObertaAuthorizationRq
  URL = ViaObertaAuthorizationConfig.url

  def initialize(organization)
    @ine = organization.via_oberta_settings['ine']
    @municipal_code = organization.via_oberta_settings['municipal_code']
    @province_code = organization.via_oberta_settings['province_code']
  end

  def send_rq(document_type:, id_document:)
    request = ::ViaObertaAuthorization::ViaObertaData.new(document_type, id_document)
    send_soap_request(request)
  end

  private

  # Wraps the request in a SOAP envelope and sends it.
  def send_soap_request(request)
    Faraday.post URL do |http_request|
      http_request.headers["Content-Type"] = "text/xml"
      http_request.headers["SOAPAction"] = "servicio"
      http_request.body = request_body(request)
      puts http_request.body
    end
  end

  def request_body(request)
    timestamp = Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <env:Envelope
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:impl="http://gencat.net/scsp/esquemes/peticion"
          xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
        <env:Body>
          <open:procesa>
            <Peticion xmlns="http://gencat.net/scsp/esquemes/peticion">
              <Atributos>
                <IdPeticion>DECIDIM-PAD-#{@ine}-#{timestamp}</IdPeticion>
                <NumElementos>1</NumElementos>
                <TimeStamp>#{timestamp}</TimeStamp>
                <CodigoCertificado>RESIDENT_MUNICIPI</CodigoCertificado>
                <CodigoProducto>PADRO</CodigoProducto>
                <DatosAutorizacion>
                  <IdentificadorSolicitante>#{@ine}</IdentificadorSolicitante>
                  <NombreSolicitante>Ajuntament de Tarragona</NombreSolicitante>
                  <Finalidad>#{ViaObertaAuthorizationConfig.purpose}</Finalidad>
                </DatosAutorizacion>
                <Emisor>
                  <NifEmisor>Q0801175A</NifEmisor>
                  <NombreEmisor>CAOC</NombreEmisor>
                </Emisor>
              </Atributos>
              <Solicitudes>
                <SolicitudTransmision>
                  <DatosGenericos>
                    <Emisor>
                      <NifEmisor>Q0801175A</NifEmisor>
                      <NombreEmisor>CAOC</NombreEmisor>
                    </Emisor>
                    <Solicitante>
                      <IdentificadorSolicitante>#{@ine}</IdentificadorSolicitante>
                      <NombreSolicitante>CAOC</NombreSolicitante>
                      <Finalidad>Ajuntament de Tarragona</Finalidad>
                      <Consentimiento>Si</Consentimiento>
                    </Solicitante>
                    <Transmision>
                      <CodigoCertificado>RESIDENT_MUNICIPI</CodigoCertificado>
                      <IdSolicitud>AOC00000000100373</IdSolicitud>
                    </Transmision>
                  </DatosGenericos>
                  <DatosEspecificos>
                    <ns1:peticionResidente xmlns:ns1="http://www.aocat.net/padro">
                      <ns1:numExpediente>#{request.id_document}</ns1:numExpediente>
                      <ns1:tipoDocumentacion>#{request.document_type}</ns1:tipoDocumentacion>
                      <ns1:documentacion>#{request.id_document}</ns1:documentacion>
                      <ns1:codigoMunicipio>#{@municipal_code}</ns1:codigoMunicipio> 
                      <ns1:codigoProvincia>#{@province_code}</ns1:codigoProvincia>
                      <ns1:idescat>1</ns1:idescat>
                    </ns1:peticionResidente>
                  </DatosEspecificos>
                </SolicitudTransmision>
              </Solicitudes>
            </Peticion>
          </open:procesa>
        </env:Body>
      </env:Envelope>
    XML
  end

  def create_token(nonce, fecha)
    Digest::SHA512.base64digest("#{nonce}#{fecha}#{@public_key}")
  end

  # Encode date AND time into an API timestamp format
  def encode_time(time = Time.now.utc)
    time.strftime("%Y%m%d%H%M%S")
  end

  # Encode only date into an API timestamp format
  def encode_date(date)
    "#{date.strftime("%Y%m%d")}000000"
  end

  def big_random
    # https://stackoverflow.com/questions/16546038/a-long-bigger-than-long-max-value
    # In fact is between [-2**63..2**63] but I experienced some errors when random number
    # was close to the limits.
    rand(2**24..2**48 - 1)
  end
end

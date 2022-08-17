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
    @organization = organization
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
    timestamp = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L")
    req_id = "#{@ine}-#{Time.now.to_i}"
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <soapenv:Envelope
          xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:open="http://www.openuri.org/"
          xmlns:pet="http://gencat.net/scsp/esquemes/peticion">
        <soapenv:Header/>
        <soapenv:Body>
          <open:procesa>
            <ns1:Peticion xmlns:ns1="http://gencat.net/scsp/esquemes/peticion">
              <ns1:Atributos>
                <ns1:IdPeticion>#{req_id}</ns1:IdPeticion>
                <ns1:NumElementos>1</ns1:NumElementos>
                <ns1:TimeStamp>#{timestamp}</ns1:TimeStamp>
                <ns1:Estado/>
                <ns1:CodigoCertificado>RESIDENT_MUNICIPI</ns1:CodigoCertificado>
                <ns1:CodigoProducto>PADRO</ns1:CodigoProducto>
                <ns1:DatosAutorizacion>
                  <ns1:IdentificadorSolicitante>#{@ine}</ns1:IdentificadorSolicitante>
                  <ns1:NombreSolicitante>#{@organization.name}</ns1:NombreSolicitante>
                  <ns1:Finalidad>#{ViaObertaAuthorizationConfig.purpose}</ns1:Finalidad>
                </ns1:DatosAutorizacion>
                <ns1:Emisor>
                  <ns1:NifEmisor>#{ViaObertaAuthorizationConfig.nif}</ns1:NifEmisor>
                  <ns1:NombreEmisor>#{@organization.name}</ns1:NombreEmisor>
                </ns1:Emisor>
                <ns1:IdSolicitanteOriginal>MAP</ns1:IdSolicitanteOriginal>
                <ns1:NomSolicitanteOriginal>MAP</ns1:NomSolicitanteOriginal>
              </ns1:Atributos>
              <ns1:Solicitudes>
                <ns1:SolicitudTransmision>
                  <ns1:DatosGenericos>
                    <ns1:Emisor>
                      <ns1:NifEmisor>#{ViaObertaAuthorizationConfig.nif}</ns1:NifEmisor>
                      <ns1:NombreEmisor>#{@organization.name}</ns1:NombreEmisor>
                    </ns1:Emisor>
                    <ns1:Solicitante>
                      <ns1:IdentificadorSolicitante>#{@ine}</ns1:IdentificadorSolicitante>
                      <ns1:NombreSolicitante>#{@organization.name}</ns1:NombreSolicitante>
                      <ns1:Finalidad>#{ViaObertaAuthorizationConfig.purpose}</ns1:Finalidad>
                      <ns1:Consentimiento>Si</ns1:Consentimiento>
                    </ns1:Solicitante>
                    <ns1:Transmision>
                      <ns1:CodigoCertificado>RESIDENT_MUNICIPI</ns1:CodigoCertificado>
                      <ns1:IdSolicitud>#{req_id}</ns1:IdSolicitud>
					            <ns1:FechaGeneracion>#{Time.now.strftime("%Y-%m-%d")}</ns1:FechaGeneracion>
                    </ns1:Transmision>
                  </ns1:DatosGenericos>
                  <ns1:DatosEspecificos>
                    <ns2:peticionResidenteMunicipio xmlns:ns2="http://www.aocat.net/padro">
                      <ns2:numExpediente>#{req_id}</ns2:numExpediente>
                      <ns2:tipoDocumentacion>#{request.document_type}</ns2:tipoDocumentacion>
                      <ns2:documentacion>#{request.id_document}</ns2:documentacion>
                      <ns2:codigoMunicipio>#{@municipal_code}</ns2:codigoMunicipio> 
                      <ns2:codigoProvincia>#{@province_code}</ns2:codigoProvincia>
                      <ns2:idescat>0</ns2:idescat>
                    </ns2:peticionResidenteMunicipio>
                  </ns1:DatosEspecificos>
                </ns1:SolicitudTransmision>
              </ns1:Solicitudes>
            </ns1:Peticion>
          </open:procesa>
        </soapenv:Body>
      </soapenv:Envelope>
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

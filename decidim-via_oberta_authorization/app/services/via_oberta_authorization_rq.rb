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

  def initialize(ine)
    @ine = ine
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
    end
  end

  def request_body(request)
    timestamp = Time.now.to_i
    <<~XML
      <ns4:Peticion xmlns:ns4="http://gencat.net/scsp/esquemes/peticion">
        <ns4:Atributos>
            <ns4:IdPeticion>DECIDIM-PAD-824010007-#{timestamp}</ns4:IdPeticion>
            <ns4:NumElementos>1</ns4:NumElementos>
            <ns4:TimeStamp>#{timestamp}</ns4:TimeStamp>
            <ns4:CodigoCertificado>TITULAR_PROPI</ns4:CodigoCertificado>
            <ns4:CodigoProducto>PADRO</ns4:CodigoProducto>
            <ns4:DatosAutorizacion>
                <ns4:IdentificadorSolicitante>824010007</ns4:IdentificadorSolicitante>
                <ns4:NombreSolicitante>Ajuntament de Sant Sadurni</ns4:NombreSolicitante>
                <ns4:Finalidad>PROVES</ns4:Finalidad>
            </ns4:DatosAutorizacion>
            <ns4:Emisor>
                <ns4:NifEmisor>Q0801175A</ns4:NifEmisor>
                <ns4:NombreEmisor>CAOC</ns4:NombreEmisor>
            </ns4:Emisor>
        </ns4:Atributos>
        <ns4:Solicitudes>
            <ns4:SolicitudTransmision>
                <ns4:DatosGenericos>
                    <ns4:Emisor>
                        <ns4:NifEmisor>Q0801175A</ns4:NifEmisor>
                        <ns4:NombreEmisor>CAOC</ns4:NombreEmisor>
                    </ns4:Emisor>
                    <ns4:Solicitante>
                        <ns4:IdentificadorSolicitante>824010007</ns4:IdentificadorSolicitante>
                        <ns4:NombreSolicitante>Ajuntament de Sant Sadurni</ns4:NombreSolicitante>
                        <ns4:Finalidad>PROVES</ns4:Finalidad>
                        <ns4:Consentimiento>Si</ns4:Consentimiento>
                    </ns4:Solicitante>
                    <ns4:Transmision>
                        <ns4:CodigoCertificado>TITULAR_PROPI</ns4:CodigoCertificado>
                        <ns4:IdSolicitud>DECIDIM-PAD-220427151828.98226</ns4:IdSolicitud>
                    </ns4:Transmision>
                </ns4:DatosGenericos>
                <ns4:DatosEspecificos>
                    <ns7:peticioDatosTitular>
                        <ns7:numExpediente>#{request.id_document}<ns7:numExpediente/>
                        <ns7:tipoDocumentacion>#{request.document_type}</ns7:tipoDocumentacion>
                        <ns7:documentacion>#{request.id_document}</ns7:documentacion>                 
                        <ns7:idescat>0</ns7:idescat>
                    </ns7:peticioDatosTitular>
                </ns4:DatosEspecificos>
            </ns4:SolicitudTransmision>
        </ns4:Solicitudes>
      </ns4:Peticion>
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

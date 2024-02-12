# frozen_string_literal: true

require "spec_helper"

RSpec.describe ViaObertaAuthorization do
  subject do
    allow(Rails.application.secrets).to receive(:via_oberta).and_return(JSON.parse({
      url: "https://example.net/siri-proxy/services/Sincron"
    }.to_json, object_class: Struct))

    api = ViaObertaAuthorization.new(organization)
    rs = api.call(document_type: document_type, id_document: id_document)
    rs
  end

  let(:organization) { create(:organization, name: "Decidim Test", via_oberta_settings: { nif: 12_345_678, ine: 123, municipal_code: 345, province_code: 678 }) }
  let(:id_document) { "58958982T" }
  let(:document_type) { 1 }
  let(:date) { Date.parse("20000101101010") }

  context "with participant's data" do
    before do
      stub_request(:post, "https://example.net/siri-proxy/services/Sincron")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "text/xml",
            "Soapaction" => "procesa",
            "User-Agent" => "Faraday v2.4.0"
          }
        )
        .to_return(status: 200, body: raw_response, headers: {})
    end

    context "with success response" do
      it "performs request and parses response" do
        expect(subject).to eq(ViaObertaAuthorization::ViaObertaData.new(document_type, id_document))
      end
    end
  end

  def raw_response
    <<~EODATA
      <?xml version='1.0' encoding='UTF-8'?>
        <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
        <SOAP-ENV:Header>
        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" SOAP-ENV:mustUnderstand="0">
          <wsse:BinarySecurityToken xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3" wsu:Id="XWSSGID-1658227233348-1899287595">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
          </wsse:BinarySecurityToken>
          <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="XWSSGID-16582272333451206762353">
            <ds:SignedInfo>
              <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
              <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
              <ds:Reference URI="#XWSSGID-1664173364962-910414654"><ds:Transforms>
                <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transforms>
                <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>RQKOl4tlViElyDGYQmiA0h2RR0c=</ds:DigestValue>
              </ds:Reference>
            </ds:SignedInfo>
            <ds:SignatureValue>MdoLGn7R+YjfSroVR0iN+G4IhMCU5CSYKWoNbt36tI0lC5vhxsUnuYhKS9nNpmKVdVFJ5+GCLeZs
              N7FU/3zEW9hV9oKmXyi6eNS8c6VCcmdhMBFdBA9scO+WgeadCyNpWgF5QxI1FHXZ0jeGRGeylwXS
              a2W1O2i0kyv0OVHqaBIZ4WhjVxksVYrhjU29isA0eNeRywenxtHKDcXjL1strElqr1T7wFGYkPWu
              MTan7wFn6vFzyLekII4ZtjwWShr+Q7+0ax7qXoqtZodoZxTUQYgJCBji13BvHnQyUyUv2x2+jDtS
              cTVP951j0KpFX00aJvNZZzA3QFae0T6hPBKJXg==
            </ds:SignatureValue>
            <ds:KeyInfo>
              <wsse:SecurityTokenReference xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="XWSSGID-16641733649622112546179">
                <wsse:Reference URI="#XWSSGID-1658227233348-1899287595" ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3"/>
              </wsse:SecurityTokenReference>
            </ds:KeyInfo>
          </ds:Signature>
          <wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="XWSSGID-1658227233351-1493276160">
            <wsu:Created>2022-09-26T06:22:44Z</wsu:Created>
            <wsu:Expires>2022-09-26T06:27:44Z</wsu:Expires>
          </wsu:Timestamp>
          </wsse:Security>
        </SOAP-ENV:Header>
        <SOAP-ENV:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="XWSSGID-1664173364962-910414654">
          <ns0:procesaResponse xmlns:S="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://www.openuri.org/" xmlns:ns2="http://gencat.net/scsp/esquemes/peticion" xmlns:ns3="http://gencat.net/scsp/esquemes/respuesta">
            <ns3:Respuesta>
              <ns3:Atributos>
                <ns3:IdPeticion>4314820002-1664173362</ns3:IdPeticion>
                <ns3:NumElementos>1</ns3:NumElementos>
                <ns3:TimeStamp>2022-09-26T08:22:44.707+02:00</ns3:TimeStamp>
                <ns3:Estado>
                  <ns3:CodigoEstado>0003</ns3:CodigoEstado>
                  <ns3:LiteralError>OK</ns3:LiteralError>
                  <ns3:TiempoEstimadoRespuesta>0</ns3:TiempoEstimadoRespuesta>
                </ns3:Estado>
                <ns3:CodigoCertificado>RESIDENT_MUNICIPI</ns3:CodigoCertificado>
                <ns3:CodigoProducto>PADRO</ns3:CodigoProducto>
                <ns3:Emisor>
                  <ns3:NifEmisor>P4315000B</ns3:NifEmisor>
                  <ns3:NombreEmisor>Decidim Catalunya Pilotatge</ns3:NombreEmisor>
                </ns3:Emisor>
                <ns3:IdSolicitanteOriginal>MAP</ns3:IdSolicitanteOriginal>
                <ns3:NomSolicitanteOriginal>MAP</ns3:NomSolicitanteOriginal>
              </ns3:Atributos>
              <ns3:Transmisiones>
                <ns3:TransmisionDatos>
                  <ns3:DatosGenericos>
                    <ns3:Emisor>
                      <ns3:NifEmisor>P4315000B</ns3:NifEmisor>
                      <ns3:NombreEmisor>Decidim Catalunya Pilotatge</ns3:NombreEmisor>
                    </ns3:Emisor>
                    <ns3:Solicitante>
                      <ns3:IdentificadorSolicitante>4314820002</ns3:IdentificadorSolicitante>
                      <ns3:NombreSolicitante>Decidim Catalunya Pilotatge</ns3:NombreSolicitante>
                      <ns3:Finalidad>PROVES</ns3:Finalidad>
                      <ns3:Consentimiento>Si</ns3:Consentimiento>
                    </ns3:Solicitante>
                    <ns3:Transmision>
                      <ns3:CodigoCertificado>RESIDENT_MUNICIPI</ns3:CodigoCertificado>
                      <ns3:IdSolicitud>4314820002-1664173362</ns3:IdSolicitud>
                      <ns3:IdTransmision/>
                      <ns3:FechaGeneracion>2022-09-26</ns3:FechaGeneracion>
                    </ns3:Transmision>
                  </ns3:DatosGenericos>
                  <ns3:DatosEspecificos>
                    <aoc:respuestaResidenteMunicipio xmlns:aoc="http://www.aocat.net/padro" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                      <aoc:numExpediente>4314820002-1664173362</aoc:numExpediente>
                      <aoc:tipoDocumentacion>1</aoc:tipoDocumentacion>
                      <aoc:documentacion>47762271B</aoc:documentacion>
                      <aoc:codigoMunicipio>101</aoc:codigoMunicipio>
                      <aoc:codigoProvincia>08</aoc:codigoProvincia>
                      <aoc:codigoResultado>1</aoc:codigoResultado>
                      <aoc:fuente>PADRON</aoc:fuente>
                    </aoc:respuestaResidenteMunicipio>
                  </ns3:DatosEspecificos>
                </ns3:TransmisionDatos>
              </ns3:Transmisiones>
            </ns3:Respuesta>
          </ns0:procesaResponse>
        </SOAP-ENV:Body></SOAP-ENV:Envelope>
    EODATA
  end
end

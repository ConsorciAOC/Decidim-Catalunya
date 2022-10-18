# frozen_string_literal: true

class ViaObertaAuthorization
  ViaObertaData = Struct.new(:document_type, :id_document)

  def initialize(organization)
    @organization = organization
  end

  def call(document_type:, id_document:)
    request = build_request
    raw_response = request.send_rq(document_type: document_type, id_document: id_document)
    response = ViaObertaAuthorizationRs.new(raw_response)
    return unless response.active?

    ViaObertaData.new(document_type, id_document)
  end

  private

  def build_request
    ViaObertaAuthorizationRq.new(@organization)
  end
end

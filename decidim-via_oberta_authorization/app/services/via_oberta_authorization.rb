# frozen_string_literal: true

class ViaObertaAuthorization
  ViaObertaData = Struct.new(:document_type, :id_document)

  def initialize(ine)
    @ine = ine
  end

  def call(document_type:, id_document:)
    request = build_request
    raw_response = request.send_rq(document_type: document_type, id_document: id_document)
    response = ViaObertaAuthorizationRs.new(raw_response)
    return unless response.birth_date.present? && response.active?

    ViaObertaData.new(document_type, id_document, response.birth_date)
  end

  private

  def build_request
    ViaObertaAuthorizationRq.new(@ine)
  end
end

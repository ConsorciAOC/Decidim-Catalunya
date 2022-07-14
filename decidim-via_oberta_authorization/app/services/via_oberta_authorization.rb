# frozen_string_literal: true

class ViaObertaAuthorization
  ViaObertaData = Struct.new(:document_type, :id_document, :birthdate)

  def initialize(username, password, ens)
    @username = username
    @password = password
    @ens = ens
  end

  def call(document_type:, id_document:, birthdate:)
    request = build_request
    raw_response = request.send_rq(document_type: document_type, id_document: id_document, birthdate: birthdate)
    response = ViaObertaAuthorizationRs.new(raw_response)
    return unless response.birth_date.present? && response.active?

    ViaObertaData.new(document_type, id_document, response.birth_date)
  end

  private

  def build_request
    ViaObertaAuthorizationRq.new(@username, @password, @ens)
  end
end

# frozen_string_literal: true

class ViaObertaAuthorizationConfig
  DOCUMENT_TYPE = {
    "nif" => "1",
    "passport" => "2",
    "residence_card" => "3",
    "nie" => "4"
  }.freeze

  class << self
    def url
      Rails.application.secrets.via_oberta[:url]
    end

    def purpose
      if Rails.env == "production"
        "GESTTRIB"
      else
        "PROVES"
      end
    end
  end
end

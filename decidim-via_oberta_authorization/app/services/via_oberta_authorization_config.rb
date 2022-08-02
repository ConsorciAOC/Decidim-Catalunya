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
      if Rails.env == :production
        "GESTTRIB"
      else
        "PROVES"
      end
    end

    def signer_settings
      {
        certificate: Rails.application.secrets.via_oberta['certificat'],
        private_key_cert: Rails.application.secrets.via_oberta['private_key_cert'],
        private_key_pass: Rails.application.secrets.via_oberta['private_key_pass']
      }
    end
  end
end

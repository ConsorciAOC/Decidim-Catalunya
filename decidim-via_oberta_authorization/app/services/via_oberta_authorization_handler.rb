# frozen_string_literal: true

require "virtus/multiparams"

# An AuthorizationHandler that uses the ViaObertaAuthorizationService to create authorizations
class ViaObertaAuthorizationHandler < Decidim::AuthorizationHandler
  include Virtus::Multiparams

  # This is the input (from the user) to validate against
  attribute :document_type, Symbol
  attribute :id_document, String

  # This is the validation to perform
  # If passed, is authorized
  validates :document_type, inclusion: { in: [:nif, :passport, :residence_card, :nie] }, presence: true
  validates :id_document, presence: true
  validate :censed

  def census_document_types
    [:nif, :passport, :residence_card, :nie].map do |type|
      [
        I18n.t(type, scope: %w(decidim authorization_handlers
                               via_oberta_authorization_handler
                               document_types)),
        type
      ]
    end
  end

  # Checks if the id_document belongs to the census
  def censed
    if census_for_user.nil?
      errors.add(:id_document, I18n.t("decidim.census.errors.messages.not_censed"))
    end
  end

  def unique_id
    return unless census_for_user

    Digest::SHA256.hexdigest(
      "#{census_for_user.id_document}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  def census_for_user
    return @census_for_user if defined? @census_for_user
    return unless organization

    @service = ViaObertaAuthorization.new(organization)
    @census_for_user = @service.call(
      document_type: ::ViaObertaAuthorizationConfig::DOCUMENT_TYPE[document_type],
      id_document: id_document
    )
  end

  private

  def organization
    current_organization || user.try(:organization)
  end
end

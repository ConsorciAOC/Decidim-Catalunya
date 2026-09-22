# frozen_string_literal: true

require "spec_helper"

module Decidim
  module System
    # Customization for GoogleTagManager: UpdateOrganization writes the
    # google_tag_manager_settings from the form into the organization before saving.
    describe UpdateOrganization do
      subject(:command) { described_class.new(organization.id, form) }

      let(:organization) { create(:organization) }
      let(:form) { UpdateOrganizationForm.new(params) }
      let(:params) do
        {
          name: { en: "Gotham City", ca: "Gotham City", es: "Gotham City" },
          short_name: { en: "GothamCity", ca: "GothamCity", es: "GothamCity" },
          host: "gotham.example.org",
          default_locale: "en",
          users_registration_mode: "enabled",
          file_upload_settings: params_for_uploads(Decidim::OrganizationSettings.default(:upload)),
          google_tag_manager_settings: { "entity_name" => "Gotham City Council" }
        }
      end

      def params_for_uploads(hash)
        hash.to_h do |key, value|
          case value
          when Hash then value = params_for_uploads(value)
          when Array then value = value.join(",")
          end
          [key, value]
        end
      end

      context "when the form is valid" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "writes the GTM entity name into the organization" do
          command.call

          expect(organization.reload.google_tag_manager_settings["entity_name"]).to eq("Gotham City Council")
        end

        it "still updates the core attributes" do
          command.call

          expect(translated(organization.reload.name)).to eq("Gotham City")
        end
      end

      context "when the form is invalid" do
        before { allow(form).to receive(:invalid?).and_return(true) }

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end
    end
  end
end

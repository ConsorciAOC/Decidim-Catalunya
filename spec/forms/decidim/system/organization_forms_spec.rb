# frozen_string_literal: true

require "spec_helper"

module Decidim
  module System
    # Customization for GoogleTagManager: both system organization forms are extended
    # with a google_tag_manager_settings jsonb attribute, and UpdateOrganizationForm/
    # RegisterOrganizationForm map the entity_code from the trusted-ids census config.
    describe "GoogleTagManager organization form overrides" do
      describe RegisterOrganizationForm do
        it "includes the override" do
          expect(described_class.included_modules).to include(GoogleTagManagerOrganizationFormOverride)
        end

        it "exposes the google_tag_manager_settings attributes" do
          form = described_class.new(google_tag_manager_settings: { entity_code: "01", entity_name: "Gotham City Council" })

          expect(form.google_tag_manager_settings["entity_code"]).to eq("01")
          expect(form.google_tag_manager_settings["entity_name"]).to eq("Gotham City Council")
        end
      end

      describe UpdateOrganizationForm do
        let(:organization) do
          create(:organization, google_tag_manager_settings: { "entity_name" => "Gotham City Council" })
        end

        it "includes the override" do
          expect(described_class.included_modules).to include(GoogleTagManagerOrganizationFormOverride)
        end

        context "when the organization has a trusted-ids census config" do
          let(:census_config) { double(settings: { "ine" => "08019" }, expiration_days: 30, tos: {}) }

          before { allow(organization).to receive(:trusted_ids_census_config).and_return(census_config) }

          it "fills entity_code from the census INE via map_model" do
            form = described_class.from_model(organization)

            expect(form.google_tag_manager_settings["entity_code"]).to eq("08019")
          end
        end

        context "when the organization has no trusted-ids census config" do
          it "maps the core attributes without raising" do
            form = described_class.from_model(organization)

            expect(form.host).to eq(organization.host)
            expect(form.google_tag_manager_settings["entity_name"]).to eq("Gotham City Council")
          end
        end
      end
    end
  end
end

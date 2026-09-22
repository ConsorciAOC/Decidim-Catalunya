# frozen_string_literal: true

require "spec_helper"

module Decidim
  module System
    # Customization for GoogleTagManager: CreateOrganization persists the
    # google_tag_manager_settings coming from the form after the core creation.
    describe CreateOrganization do
      subject(:command) { described_class.new(form) }

      let(:form) { RegisterOrganizationForm.new(params) }
      let(:params) do
        {
          name: "Gotham City",
          short_name: "GothamCity",
          host: "decide.example.org",
          reference_prefix: "JKR",
          organization_admin_name: "Fiorello Henry La Guardia",
          organization_admin_email: "f.laguardia@example.org",
          available_locales: ["en"],
          default_locale: "en",
          users_registration_mode: "enabled",
          force_users_to_authenticate_before_access_organization: "false",
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

        it "persists the GTM entity name" do
          command.call

          expect(Decidim::Organization.last.google_tag_manager_settings["entity_name"]).to eq("Gotham City Council")
        end

        it "still creates the organization with its core attributes" do
          expect { command.call }.to change(Decidim::Organization, :count).by(1)

          organization = Decidim::Organization.last
          expect(organization.host).to eq("decide.example.org")
          expect(translated(organization.name)).to eq("Gotham City")
        end
      end

      context "when the form is invalid" do
        before { allow(form).to receive(:invalid?).and_return(true) }

        it "broadcasts invalid and creates nothing" do
          expect { command.call }.to broadcast(:invalid)
          expect(Decidim::Organization.count).to eq(0)
        end
      end
    end
  end
end

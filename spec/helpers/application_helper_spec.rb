# frozen_string_literal: true

require "spec_helper"

describe ApplicationHelper do
  describe "#google_tag_manager_code" do
    around do |example|
      original = ENV.fetch("GOOGLE_TAG_MANAGER_CODE", nil)
      ENV["GOOGLE_TAG_MANAGER_CODE"] = env_value
      example.run
      ENV["GOOGLE_TAG_MANAGER_CODE"] = original
    end

    context "when the ENV variable is set" do
      let(:env_value) { "GTM-ABC123" }

      it "returns the container id" do
        expect(helper.google_tag_manager_code).to eq("GTM-ABC123")
      end
    end

    context "when the ENV variable is blank" do
      let(:env_value) { "" }

      it "returns an empty string" do
        expect(helper.google_tag_manager_code).to eq("")
      end
    end
  end

  describe "#google_tag_manager_data_layer" do
    let(:organization) do
      create(:organization, name: { "en" => "Gotham City" }, google_tag_manager_settings: gtm_settings)
    end
    let(:gtm_settings) { { "entity_name" => "Gotham City Council" } }

    it "returns an html_safe dataLayer with the tenant and entity name" do
      layer = helper.google_tag_manager_data_layer(organization)

      expect(layer).to be_html_safe
      expect(layer).to include(%("nomTenant" : "Gotham City"))
      expect(layer).to include(%("nomEns" : "Gotham City Council"))
    end

    context "when the organization has no google_tag_manager_settings" do
      let(:gtm_settings) { nil }

      it "renders an empty entity name" do
        expect(helper.google_tag_manager_data_layer(organization)).to include(%("nomEns" : ""))
      end
    end

    context "when the organization has a trusted-ids census config" do
      let(:census_config) { double(settings: { "ine" => "08019" }) }

      before do
        allow(organization).to receive(:trusted_ids_census_config).and_return(census_config)
      end

      it "sets CODIENS from the census INE code" do
        expect(helper.google_tag_manager_data_layer(organization)).to include(%("CODIENS" : "08019"))
      end
    end

    context "when the organization has no trusted-ids census config" do
      it "leaves CODIENS empty" do
        expect(helper.google_tag_manager_data_layer(organization)).to include(%("CODIENS" : ""))
      end
    end
  end
end

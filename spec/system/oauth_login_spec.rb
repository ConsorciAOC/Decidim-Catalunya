# frozen_string_literal: true

require "spec_helper"

describe "Homepage" do
  include Decidim::SanitizeHelper

  let!(:organization) do
    create(
      :organization,
      name: "Decidim Application",
      default_locale: :en,
      available_locales: [:ca, :en, :es],
      omniauth_settings: omniauth_settings
    )
  end
  let(:omniauth_settings) do
    {
      "omniauth_settings_valid_enabled" => enabled,
      "omniauth_settings_valid_client_id" => "",
      "omniauth_settings_valid_client_secret" => ""
    }
  end
  let(:enabled) { false }
  let(:custom_login_screen) { true }

  before do
    allow(Decidim::TrustedIds).to receive(:custom_login_screen).and_return(custom_login_screen)
    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  it "loads and shows organization name and main blocks" do
    expect(page).to have_content("New to the platform?")
    expect(page).to have_no_content("Continue with verified ID")
  end

  context "when VALID oauth is enabled" do
    let(:enabled) { true }

    it "shows the VALID button" do
      expect(page).to have_no_content("New to the platform?")
      expect(page).to have_content("Continue with verified ID")
    end

    context "and no custom screen is set" do
      let(:custom_login_screen) { false }

      it "shows the default screen" do
        expect(page).to have_content("New to the platform?")
        expect(page).to have_no_content("Continue with verified ID")
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe "Organizations", type: :system do
  let(:system_admin) { create(:admin) }

  context "when an admin authenticated" do
    before do
      login_as system_admin, scope: :admin
      visit decidim_system.new_organization_path
    end

    describe "creating an organization" do
      it "creates a new organization" do
        fill_in "Name", with: "Ajuntament de Vilaexemple"
        fill_in "Host", with: "www.ajuntamentdevilaexemple.example.net"
        fill_in "Secondary hosts", with: "foo.citizen.corp\n\rbar.example.net"
        fill_in "Reference prefix", with: "CCORP"
        fill_in "Organization admin name", with: "City Mayor"
        fill_in "Organization admin email", with: "mayor@example.net"
        check "organization_available_locales_en"
        choose "organization_default_locale_en"
        choose "Allow participants to register and login"
        click_button "Show advanced settings"
        fill_in "Entity name", with: "Aj. de Vilaexemple"

        click_button "Create organization & invite admin"

        expect(page).to have_css("div.flash.success")
        expect(page).to have_content("Ajuntament de Vilaexemple")
      end
    end

    describe "editing an organization" do
      let!(:organization) { create(:organization, name: "Vilagent") }

      before do
        click_link "Organizations"
        within "table tbody" do
          first("tr").click_link "Edit"
        end
      end

      it "edits the data" do
        fill_in "Name", with: "Visca Vilagent!"
        fill_in "Host", with: "vilagent.example.org"
        fill_in "Secondary hosts", with: "foobar.vilagent.net\n\rbar.vilagent.corp"
        choose "Don't allow participants to register, but allow existing participants to login"

        click_button "Show advanced settings"
        check "organization_omniauth_settings_facebook_enabled"
        fill_in "organization_omniauth_settings_facebook_app_id", with: "facebook-app-id"
        fill_in "organization_omniauth_settings_facebook_app_secret", with: "facebook-app-secret"

        # Via Oberta
        fill_in "organization_nif", with: "00000000T"
        fill_in "organization_ine", with: "01234"
        fill_in "organization_municipal_code", with: "17666"
        fill_in "organization_province_code", with: "171717"

        # Google Tag Manager dataLayer
        fill_in "organization_entity_name", with: "Aj. de Vilagent"

        click_button "Save"

        expect(page).to have_css("div.flash.success")
        expect(page).to have_content("Visca Vilagent!")

        visit decidim_system.edit_organization_path(organization)
        click_button "Show advanced settings"
        expect(page.find("[id=organization_nif]")["value"]).to eq "00000000T"
        expect(page.find("[id=organization_ine]")["value"]).to eq "01234"
        expect(page.find("[id=organization_municipal_code]")["value"]).to eq "17666"
        expect(page.find("[id=organization_province_code]")["value"]).to eq "171717"
        expect(page.find("[id=organization_entity_name]")["value"]).to eq "Aj. de Vilagent"
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

# Customization for GoogleTagManager: the System organization advanced settings
# (deface on _advanced_settings + _google_tag_manager_settings partial) exposes an
# editable entity_name field and a disabled entity_code field.
describe "System organization GTM settings" do
  let(:system_admin) { create(:admin) }

  before do
    login_as system_admin, scope: :admin
    visit decidim_system.new_organization_path
  end

  it "renders the GTM settings block with an editable entity name and a disabled entity code" do
    expect(page).to have_css("#advanced-settings-panel", text: "Google Tag Manager Settings", visible: :all)
    expect(page).to have_field("organization_entity_name", visible: :all)
    expect(page).to have_field("organization_entity_code", disabled: true, visible: :all)
  end

  it "keeps the original SMTP settings panel" do
    expect(page).to have_css("#advanced-settings-panel", text: "SMTP settings", visible: :all)
  end
end

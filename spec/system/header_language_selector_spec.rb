# frozen_string_literal: true

require "spec_helper"

# Customization: the desktop header (header/_main) renders a custom language selector
# partial (header/_header_language_selector), which only appears when the organization
# has more than one available locale.
describe "Header language selector" do
  before do
    switch_to_host(organization.host)
    visit decidim.root_path(locale: :en)
  end

  context "when the organization has multiple locales" do
    let(:organization) { create(:organization, available_locales: [:en, :ca, :es], default_locale: :en) }

    it "shows the current locale in the trigger" do
      within "#trigger-dropdown-language-chooser-header" do
        expect(page).to have_content("English")
      end
    end

    it "lists a link for each non-current locale by its name" do
      within("#dropdown-menu-language-chooser-header", visible: :all) do
        expect(page).to have_link("Català", visible: :all)
        expect(page).to have_link("Castellano", visible: :all)
        expect(page).to have_no_link("English", visible: :all)
      end
    end
  end

  context "when the organization has a single locale" do
    let(:organization) { create(:organization, available_locales: [:en], default_locale: :en) }

    it "does not render the language selector" do
      expect(page).to have_no_css("#trigger-dropdown-language-chooser-header")
    end
  end
end

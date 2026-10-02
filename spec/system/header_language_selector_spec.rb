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
      within "#trigger-dropdown-language-top" do
        expect(page).to have_content("English")
      end
    end

    it "lists a link for each non-current locale by its name" do
      within("#dropdown-menu-language-top", visible: :all) do
        expect(page).to have_link("Català", visible: :all)
        expect(page).to have_link("Castellano", visible: :all)
        expect(page).to have_no_link("English", visible: :all)
      end
    end
  end

  context "when the mobile header has up to 3 locales" do
    let(:organization) { create(:organization, available_locales: [:en, :ca, :es], default_locale: :en) }

    it "shows the custom mobile language selector" do
      within ".menu-bar__main-dropdown", visible: :all do
        expect(page).to have_css("ul.menu-bar__language-chooser li.is-active", visible: :all)
        expect(page).to have_no_css("#dropdown-trigger-language-chooser-mobile", visible: :all)
        expect(page).to have_link("English", visible: :all)
        expect(page).to have_link("Català", visible: :all)
        expect(page).to have_link("Castellano", visible: :all)
      end
    end
  end

  context "when the mobile header has more than 3 locales" do
    around do |example|
      original_i18n_locales = I18n.available_locales
      original_decidim_locales = Decidim.available_locales
      I18n.available_locales = (original_i18n_locales | [:fr])
      Decidim.available_locales = (original_decidim_locales | [:fr])
      example.run
    ensure
      I18n.available_locales = original_i18n_locales
      Decidim.available_locales = original_decidim_locales
    end

    let(:organization) { create(:organization, available_locales: [:en, :ca, :es, :fr], default_locale: :en) }

    it "shows the original mobile language dropdown selector" do
      within ".menu-bar__main-dropdown", visible: :all do
        expect(page).to have_css("#dropdown-trigger-language-chooser-mobile", visible: :all)
        expect(page).to have_no_css("#dropdown-menu-language-chooser-mobile ul.menu-bar__language-chooser li.is-active", visible: :all)
      end
    end
  end

  context "when the organization has a single locale" do
    let(:organization) { create(:organization, available_locales: [:en], default_locale: :en) }

    it "does not render the language selector" do
      expect(page).to have_no_css("#trigger-dropdown-language-top")
    end
  end
end

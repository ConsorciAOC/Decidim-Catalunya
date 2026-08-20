# frozen_string_literal: true

require "spec_helper"

# Customization for GoogleTagManager: the loader script is injected in the public
# <head> (_head_extra) and <body> (_wrapper deface) and only rendered when the
# GOOGLE_TAG_MANAGER_CODE env var is present. The dataLayer is always rendered.
describe "Google Tag Manager" do
  let(:organization) { create(:organization, name: { en: "Gotham City" }) }

  before { switch_to_host(organization.host) }

  def with_gtm_code(value)
    original = ENV.fetch("GOOGLE_TAG_MANAGER_CODE", nil)
    ENV["GOOGLE_TAG_MANAGER_CODE"] = value
    yield
  ensure
    ENV["GOOGLE_TAG_MANAGER_CODE"] = original
  end

  context "when the GTM code is present" do
    it "renders the loader script, the container id and the dataLayer" do
      with_gtm_code("GTM-TEST01") do
        visit decidim.root_path

        expect(page.html).to include("www.googletagmanager.com/gtm.js")
        expect(page.html).to include("GTM-TEST01")
        expect(page.html).to include("dataLayer = [")
      end
    end
  end

  context "when the GTM code is blank" do
    it "does not render the loader script but keeps the layout and dataLayer" do
      with_gtm_code("") do
        visit decidim.root_path

        expect(page.html).not_to include("www.googletagmanager.com/gtm.js")
        expect(page).to have_css(".layout-container")
        expect(page.html).to include("dataLayer = [")
      end
    end
  end
end

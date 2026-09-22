# frozen_string_literal: true

require "spec_helper"

# Customization for GoogleTagManager: the admin header (decidim-admin _header deface)
# injects the loader script (after the CSRF meta tags) but no dataLayer.
describe "Google Tag Manager in the admin panel" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  def with_gtm_code(value)
    original = ENV.fetch("GOOGLE_TAG_MANAGER_CODE", nil)
    ENV["GOOGLE_TAG_MANAGER_CODE"] = value
    yield
  ensure
    ENV["GOOGLE_TAG_MANAGER_CODE"] = original
  end

  context "when the GTM code is present" do
    it "renders the loader script without a dataLayer" do
      with_gtm_code("GTM-ADMIN9") do
        visit decidim_admin.root_path

        expect(page.html).to include("www.googletagmanager.com/gtm.js")
        expect(page.html).to include("GTM-ADMIN9")
        expect(page.html).not_to include("dataLayer = [")
      end
    end
  end

  context "when the GTM code is blank" do
    it "does not render the loader script" do
      with_gtm_code("") do
        visit decidim_admin.root_path

        expect(page.html).not_to include("www.googletagmanager.com/gtm.js")
      end
    end
  end
end

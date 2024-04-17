# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Overrides" do
  it "remove overrides after upgrading to v0.28" do
    # - Check header and application overrides views to set Google Tag Manager (see #22 and "Add Google Tag Manager to admin backoffice" in the README)
    # - Remove `survey_confirmation_mailer` translations when Decidim has them
    expect(Decidim.version).to be < "0.28"
  end
end

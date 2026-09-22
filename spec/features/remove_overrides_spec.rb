# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Overrides" do
  it "remove overrides after upgrading to v0.32" do
    # - Check header and application overrides views to set Google Tag Manager (see #22 and "Add Google Tag Manager to admin backoffice" in the README)
    expect(Decidim.version).to be < "0.32"
  end
end

# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/views/layouts/decidim/header/_main.html.erb" => "a090eeca739613446d2eab8f4de513b1",
      "/app/views/layouts/decidim/header/_mobile_language_choose.html.erb" => "e1669058b86213938831646458886a96",
      "/app/views/layouts/decidim/header/_menu_breadcrumb_main_dropdown_mobile.html.erb" => "f3e4d211da02d797faf90705e0b825c1",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "25642b423f3b3a1ac9c69bf558a6b791",
      "/app/views/layouts/decidim/_wrapper.html.erb" => "4e5aab592d986e3a9967371bd368ec4f"
    }
  },
  {
    package: "decidim-admin",
    files: {
      "/app/views/layouts/decidim/admin/_header.html.erb" => "6e5893f735d2097f0e55e8b6666cb201"
    }
  },
  {
    package: "decidim-system",
    files: {
      "/app/views/decidim/system/organizations/_advanced_settings.html.erb" => "7c6710869e89f34f8acccac42cb68a37",
      "/app/commands/decidim/system/create_organization.rb" => "ad7faec3a21ced65054748dc2a4a119b",
      "/app/commands/decidim/system/update_organization.rb" => "551cb589c40db2a07e294f5dd3f500c0",
      "/app/forms/decidim/system/register_organization_form.rb" => "e194bfdb6819aa55b6870307dcd24340",
      "/app/forms/decidim/system/update_organization_form.rb" => "631ed13dc98e4bdfd39e60157d995672"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      next unless spec

      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end

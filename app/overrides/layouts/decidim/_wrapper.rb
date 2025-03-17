# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
                     name: "add_google_tag_manager_to_body",
                     insert_before: ".layout-container",
                     original: "e9d156be0184f0a4576b5c7790a8c0e2d2e2ac73") do
  <<-EOGTM
  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%= google_tag_manager_code %>"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
  EOGTM
end

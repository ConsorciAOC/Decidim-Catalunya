# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
  name: "add_google_tag_manager_to_body",
  insert_before: "div.off-canvas-wrapper",
  :original => '5609b164ff19d67a2787c4ead8908da8e7a493d1') do
  <<-EOGTM
  <!-- Google Tag Manager (noscript) -->
  <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%= google_tag_manager_code %>"
  height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager (noscript) -->
  EOGTM
end

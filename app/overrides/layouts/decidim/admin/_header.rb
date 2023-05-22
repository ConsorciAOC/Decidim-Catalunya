# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/admin/_application",
                     name: "add_google_tag_manager_to_admin_header",
                     insert_after: "title",
                     original: "0710a40f1df23769d6c2001dd49d4e5f6389409e") do
  <<-EOGTM
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=<%= google_tag_manager_code %>"
    height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
  EOGTM
end

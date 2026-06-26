# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
                     name: "add_google_tag_manager_to_body",
                     insert_before: ".layout-container",
                     original: "8c941ecda3e857a2f215737a1ead06d0dec89dc2",
                     text: "<%= render partial: 'layouts/decidim/google_tag_manager' %>")

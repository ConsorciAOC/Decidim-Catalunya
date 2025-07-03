# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
                     name: "add_google_tag_manager_to_body",
                     insert_before: ".layout-container",
                     original: "e9d156be0184f0a4576b5c7790a8c0e2d2e2ac73",
                     text: "<%= render partial: 'layouts/decidim/google_tag_manager' %>")

# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/admin/_header",
                     name: "add_google_tag_manager_to_admin",
                     insert_before: "meta",
                     original: "fe1629c287f8302be09a6e085497f082bdf0de2a",
                     text: "<%= render partial: 'layouts/decidim/google_tag_manager' %>")

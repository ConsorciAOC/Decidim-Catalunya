# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/_wrapper",
                     name: "add_google_tag_manager_to_body",
                     insert_before: ".layout-container",
                     original: "98fdcbd4545029e029932ac0475a8a45ed082f4a",
                     text: "<%= render partial: 'layouts/decidim/google_tag_manager' %>")

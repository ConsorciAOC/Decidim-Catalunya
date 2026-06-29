# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/admin/_header",
                     name: "add_google_tag_manager_to_admin",
                     insert_after: "erb[loud]:contains('csrf_meta_tags')",
                     original: "47a04df83b17bd3e03febe129ad8fd65e6680f48",
                     text: "<%= render partial: 'layouts/decidim/google_tag_manager' %>")

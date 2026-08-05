# frozen_string_literal: true

Deface::Override.new(virtual_path: "layouts/decidim/header/_main",
                     name: "add_top_language_selector",
                     insert_top: ".main-bar__links-desktop",
                     original: "76ed4ace090e96db69e9bb0a7cc69a5b4437446b",
                     text: "<%= render partial: 'layouts/decidim/header/header_language_selector' %>")

# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/system/organizations/_advanced_settings",
                     name: "add_google_tag_manager_settings",
                     insert_top: "#advanced-settings-panel",
                     original: "9ceaa0e639f0b46fd349f0ca219328a53f400882",
                     text: "<%= render partial: 'google_tag_manager_settings', locals: { f: f } %>")

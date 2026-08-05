# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/system/organizations/_advanced_settings",
                     name: "add_google_tag_manager_settings",
                     insert_top: "#advanced-settings-panel",
                     original: "964707ab651873094b0d104df6df1cca8cc981e1",
                     text: "<%= render partial: 'google_tag_manager_settings', locals: { f: f } %>")

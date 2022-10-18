# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/system/organizations/_advanced_settings",
  name: "add_via_oberta_settings",
  insert_before: "erb[loud]:contains('file_upload_settings')",
  text: "<%= render partial: 'via_oberta_settings', locals: { f: f } %>")

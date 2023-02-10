# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/system/organizations/_advanced_settings",
  name: "add_google_tag_manager_settings",
  insert_before: "erb[loud]:contains('file_upload_settings')",
  original: 'dc17eac5b47520b7031cfbe346f90d47d792db55',
  text: "<%= render partial: 'google_tag_manager_settings', locals: { f: f } %>")

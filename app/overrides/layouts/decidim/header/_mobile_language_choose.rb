# frozen_string_literal: true

# Hides original mobile language selector when the organization has more than 3 available locales, so that the custom language selector is used instead.
Deface::Override.new(virtual_path: "layouts/decidim/header/_mobile_language_choose",
                     name: "hide_original_mobile_language_selector",
                     replace: "erb[silent]:contains('if available_locales.length > 1')",
                     original: "b749263d6701cdfebc08c5ac3cd0b95cde671ffa",
                     text: "<% if available_locales.length > 3 %>")

# frozen_string_literal: true

# Adds a custom mobile language selector when the organization has less than 3 available locales
Deface::Override.new(virtual_path: "layouts/decidim/header/_menu_breadcrumb_main_dropdown_mobile",
                     name: "add_custom_mobile_language_selector",
                     insert_top: ".menu-bar__main-dropdown__top",
                     original: "2bd29b340ffe241ee07aecdc0c7a9d8992d8259f",
                     text: "<%= render partial: 'layouts/decidim/header/mobile_header_language_selector' %>")

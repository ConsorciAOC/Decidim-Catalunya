# Decidim-Catalunya

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for Decidim-Catalunya, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:
```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```
3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

## Development

```bash
bundle install
nvm use 22.14.0
npm install
bin/rails assets:precompile
bin/rails db:create db:schema:load
bin/rails db:seed
bin/rails s
```

## Backing up and restoring hero settings

Before upgrading, export the raw settings of every hero content block to a new
JSON file (the export will not overwrite an existing file):

```bash
bundle exec rake 'hero_content_block_settings:export[/secure/path/hero-settings.json]'
```

Keep the file securely outside the application repository. After upgrading, if
the CTA migration discarded existing settings, restore the missing keys with:

```bash
bundle exec rake 'hero_content_block_settings:restore[/secure/path/hero-settings.json]'
```

The restore uses the original content block and organization IDs and scope, so
run it against the same database. It preserves any current setting, including
the migrated CTA values, and only adds keys absent from the current settings.
All records are restored in one transaction; a missing or mismatched block or an
invalid backup aborts the restore. A backup from before the affected migration
is required to recover settings that were lost.

## Overrides, decorators and more.

### Add Google Tag Manager

GTM is configured per-organization from the System admin panel. View overrides live in `app/overrides/` (Deface), class overrides in `app/**/concerns/` and are wired in `config/application.rb`.

- **app/overrides/layouts/decidim/_wrapper/add_google_tag_manager_to_body.html.erb.deface**

    Add GTM in `<body>`

- **app/overrides/layouts/decidim/admin/_header/add_google_tag_manager_to_admin.html.erb.deface**

    Add GTM in admin `<head>`

- **app/overrides/decidim/system/organizations/_advanced_settings/add_google_tag_manager_settings.html.erb.deface**

    Add the GTM field to the System organization form

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
nvm use 16.9.1
npm install
bin/rails db:create db:schema:load
bin/rails db:seed
bin/rails s
```

## Overrides, decorators and more.

### Add Google Tag Manager to admin backoffice

Deface has a strange fail due to nokogiri gem and the overrides with Deface don't work when applied inside the HEAD tag. 

Nokogiri required version >= 1.6.0

See:
https://github.com/spree/deface/issues/84
https://github.com/spree/spree/issues/2633

- **app/views/layouts/decidim/admin/_application.html.erb**

    Add GTM in `<body>`

- **app/views/layouts/decidim/admin/_header.html.erb**

    Add GTM in `<head>`

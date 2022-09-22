# Decidim::ViaObertaAuthorization

A decidim package to provice user authorizations agains Via Oberta WS


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-via_oberta_authorization'
```

And then execute:

```bash
bundle install
bin/rails decidim_via_oberta_authorization:install:migrations
bin/rails db:migrate
```

## Configuration

Once installed, the following env variables can be configured:

- **VIA_OBERTA_URL**: URL to the Via Oberta census web service

## License

AGPLv3 (same as Decidim)

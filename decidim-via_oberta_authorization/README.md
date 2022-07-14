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
```

## Configuration

Once installed, the following env variables can be configured:

- **VIA_OBERTA_URL**: URL to the Via Oberta census web service

### Run tests

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
cd ../../decidim-via_oberta_authorization
```

And run tests:

```bash
bundle exec rspec spec
```

## License

AGPLv3 (same as Decidim)

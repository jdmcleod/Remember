# Remember
The journaling app I've always wanted

Bouta be lit
Stay zen

## Development

### Setup

* `yarn install`
* `bundle install`
* `rails db:create`
* `rails db:setup`

### Environment Variables

You will need to create a `.env_overrides.rb` file and set the following environment variables:

```ruby
ENV['GOOGLE_CLIENT_ID'] ||= 'development_client_id_here'
ENV['GOOGLE_CLIENT_SECRET'] ||= 'development_client_secret_here'
```

### Running the app

`bin/dev`

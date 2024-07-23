dotenv = File.expand_path('../.env_overrides.rb', __FILE__)
require dotenv if File.exist?(dotenv)

ENV['RAILS_ENV'] ||= 'development'

# OAuth2 Google Authentication
ENV["GOOGLE_CLIENT_ID"] ||= ''
ENV["GOOGLE_CLIENT_SECRET"] ||= ''


unless ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY']
  raise 'Must set ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY env variable (for development, use .env_overrides.rb)'
end

unless ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY']
  raise 'Must set ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY env variable (for development, use .env_overrides.rb)'
end

unless ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT']
  raise 'Must set ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT env variable (for development, use .env_overrides.rb)'
end

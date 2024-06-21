dotenv = File.expand_path('../.env_overrides.rb', __FILE__)
require dotenv if File.exist?(dotenv)

ENV['RAILS_ENV'] ||= 'development'

# OAuth2 Google Authentication
ENV["GOOGLE_CLIENT_ID"] ||= ''
ENV["GOOGLE_CLIENT_SECRET"] ||= ''

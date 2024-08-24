dotenv = File.expand_path('../.env_overrides.rb', __FILE__)
require dotenv if File.exist?(dotenv)

ENV['RAILS_ENV'] ||= 'development'

# OAuth2 Google Authentication
ENV["GOOGLE_CLIENT_ID"] ||= ''
ENV["GOOGLE_CLIENT_SECRET"] ||= ''

ENV["AWS_ACCESS_KEY_ID"] ||= ''
ENV["AWS_SECRET_ACCESS_KEY"] ||= ''
ENV["BUCKET_NAME"] ||= ''

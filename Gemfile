source "https://rubygems.org"

ruby "3.1.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.3"

gem "pg", '>= 1.1'
gem "puma", ">= 5.0"
gem "pg_search"

# assets
gem "stimulus-rails"
gem 'cssbundling-rails'
gem 'image_processing', '~> 1.2'
gem 'requestjs-rails'
gem 'importmap-rails' # rubocop:disable Bundler/OrderedGems - must come after requestjs-rails
gem 'sprockets-rails'
gem 'turbo-rails'
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

gem 'slim'

gem "simple_form", "~> 5.3"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'rolemodel_rails', github: 'RoleModel/rolemodel_rails'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "test-prof"
end

gem "dockerfile-rails", ">= 1.6", :group => :development

gem "aws-sdk-s3", "~> 1.159", :require => false

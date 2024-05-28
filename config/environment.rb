# Load the Rails application.
require_relative "application"

require "#{File.expand_path('../', File.dirname(__FILE__))}/env"

# Initialize the Rails application.
Rails.application.initialize!

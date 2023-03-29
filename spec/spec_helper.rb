# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'dummy/config/environment'
require 'rspec/rails'
require 'database_cleaner'

# Load JRuby SQLite3 if in that platform
if defined? JRUBY_VERSION
  require 'jdbc/sqlite3'
  Jdbc::SQLite3.load_driver
end

# require 'support/orm/#{DOORKEEPER_ORM}'

# Dir['#{File.dirname(__FILE__)}/support/{dependencies,helpers,shared}/*.rb'].sort.each { |file| require file }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec

  config.infer_base_class_for_anonymous_controllers = false

  config.include RSpec::Rails::RequestExampleGroup, type: :request

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'random'
end

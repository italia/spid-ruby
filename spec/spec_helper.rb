# frozen_string_literal: true

require "simplecov"
require "coveralls"
require "active_support/core_ext/object"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
)

SimpleCov.start do
  add_filter "spec/"
end

require "bundler/setup"
require "spid"
require "nokogiri"
require "vcr"

Dir[File.join("./spec/support/**/*.rb")].each { |f| require f }

ENV["ruby-saml/testing"] = "true" # disable ruby-saml logging

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

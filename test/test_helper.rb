ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "rubygems"
require "test/unit"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr"
  config.hook_into :webmock
end

def assert_record(record, fields, identifier = nil)
  fields.each do |key, value|
    record_value = record.send(key)
    unless record_value.nil?
      if record_value.is_a?(ActiveSupport::TimeWithZone)
        record_value = record.send(key).to_s
      end
    end

    identifier = (identifier.blank? ? record.id : identifier)

    if value.nil?
      assert_nil(record_value, "expected #{key} to be nil in #{identifier}")
    elsif value.is_a?(Hash)
      record_value = record.send(key)
      if record_value.is_a?(ActiveRecord::Base)
        assert_record(record_value, value)
      else
        assert_equal(value, record_value, "expected #{key} to equal in #{identifier}")
      end
    else
      assert_equal(value, record_value, "expected #{key} to equal in #{identifier}")
    end
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

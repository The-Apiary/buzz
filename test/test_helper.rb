ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest_assertions'

# Destroy all models because they do not get destroyed automatically
(ActiveRecord::Base.connection.tables - %w{schema_migrations}).each do |table_name|
  ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table_name};"
end

FactoryGirl.lint

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods

  def signin(user)
    cookies[:auth_token] = user.id_hash
  end
end

##
# Add desce and context aliases to the spec DSL
module Minitest::Spec::DSL
  alias :desc :describe
  alias :context :describe
end

class Minitest::Test
  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods

  # Change the displayed format of test names.
  def location
    loc = " [#{self.failure.location}]" unless passed? or error?
    test_class = self.class.to_s.gsub "::", ": "
    test_name = self.name.to_s.gsub(/\Atest_\d{4,}_/, "")
    "#{test_class} #{test_name}#{loc}"
  end

end

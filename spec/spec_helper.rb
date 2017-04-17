$VERBOSE = nil # This removes ruby warnings

require "active_mocker/rspec_helper"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = "random"
  config.mock_framework = :rspec
  config.disable_monkey_patching!
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end

  def test_tmp
    Rails.root.join(*%w(spec test_files))
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[test_tmp])
  end

  config.before(:suite) do
    FileUtils.mkdir_p(test_tmp) unless File.directory? test_tmp
  end
end

if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/lib/'
    minimum_coverage 95

    if ENV['CIRCLE_ARTIFACTS']
      coverage_dir File.join(
        '..', '..', '..', ENV['CIRCLE_ARTIFACTS'], 'coverage')
    end
  end
end

require 'webmock/rspec'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)

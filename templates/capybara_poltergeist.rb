require 'capybara/poltergeist'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    timeout: 30,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes',
                        '--disk-cache=yes'],
    debug: false
  )
end

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 15
Capybara.automatic_reload = true

Capybara.app_host = 'http://127.0.0.1:4000'
Capybara.server_host = '127.0.0.1'
Capybara.server_port = '4000'

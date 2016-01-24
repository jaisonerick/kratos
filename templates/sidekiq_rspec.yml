require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
  config.after(:each) do
    Sidekiq::Testing.fake!
  end
end

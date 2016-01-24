Rails.application.configure do
  if Rails.env.production?
    config.lograge.enabled = true
    config.log_tags = [:uuid]

    config.lograge.custom_options = lambda do |event|
      params = event.payload[:params].reject do |k|
        %w(controller action).include? k
      end

      { 'params' => params }
    end
  end
end

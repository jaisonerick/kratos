class AppBuilder < Rails::AppBuilder
  include Kratos::Actions

  def replace_gemfile
    remove_file 'Gemfile'
    template 'Gemfile.erb', 'Gemfile'
  end

  def set_ruby_to_version_being_used
    create_file '.ruby-version', "#{Kratos::RUBY_VERSION}\n"
  end

  def readme
    template 'README.md.erb', 'README.md'
  end

  def raise_on_missing_assets_in_test
    inject_into_file(
      'config/environments/test.rb',
      "\n  config.assets.raise_runtime_errors = true",
      after: 'Rails.application.configure do'
    )
  end

  def raise_on_delivery_errors
    replace_in_file 'config/environments/development.rb',
                    'raise_delivery_errors = false',
                    'raise_delivery_errors = true'
  end

  def set_test_delivery_method
    inject_into_file(
      'config/environments/development.rb',
      "\n  config.action_mailer.delivery_method = :test",
      after: 'config.action_mailer.raise_delivery_errors = true'
    )
  end

  def add_bullet_gem_configuration
    copy_file 'bullet.rb', 'config/initializers/bullet.rb'
  end

  def raise_on_unpermitted_parameters
    config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
    RUBY

    inject_into_class 'config/application.rb', 'Application', config
  end

  def provide_setup_script
    template 'bin_setup', 'bin/setup', force: true
    run 'chmod a+x bin/setup'
  end

  def provide_dev_prime_task
    copy_file 'dev.rake', 'lib/tasks/dev.rake'
  end

  def configure_generators
    config = <<-RUBY

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

    RUBY

    inject_into_class 'config/application.rb', 'Application', config
  end

  def configure_i18n_for_missing_translations
    raise_on_missing_translations_in('development')
    raise_on_missing_translations_in('test')
  end

  def configure_quiet_assets
    config = <<-RUBY
    config.quiet_assets = true
    RUBY

    inject_into_class 'config/application.rb', 'Application', config
  end


  def set_up_factory_girl_for_rspec
    copy_file 'factory_girl_rspec.rb', 'spec/support/factory_girl.rb'
  end

  def create_factories_directory
    empty_directory 'spec/factories'
  end

  def generate_rspec
    generate 'rspec:install'
  end

  def configure_rspec
    remove_file 'spec/rails_helper.rb'
    remove_file 'spec/spec_helper.rb'
    copy_file 'rails_helper.rb', 'spec/rails_helper.rb'
    copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
  end

  def enable_database_cleaner
    copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
  end

  def provide_shoulda_matchers_config
    copy_file(
      'shoulda_matchers_config_rspec.rb',
      'spec/support/shoulda_matchers.rb'
    )
  end

  def configure_spec_support_features
    empty_directory_with_keep_file 'spec/features'
  end

  def configure_ci
    template 'circle.yml.erb', 'circle.yml'
  end

  def configure_i18n_for_test_environment
    copy_file 'i18n.rb', 'spec/support/i18n.rb'
  end

  def configure_action_mailer_in_specs
    copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
  end

  def configure_capybara_poltergeist
    copy_file 'capybara_poltergeist.rb', 'spec/support/capybara_poltergeist.rb'
  end

  def configure_rspec_api_documentation
    template 'rspec_api_documentation_rspec.rb.erb', 'spec/support/rspec_api_documentation.rb'
  end

  def configure_acceptance_helpers
    copy_file 'acceptance_helpers_rspec.rb', 'spec/support/acceptance_helpers.rb'
  end

  def configure_i18n_tasks
    copy_file 'i18n_rspec.rb', 'spec/i18n_spec.rb'
    copy_file 'i18n-tasks.yml', 'config/i18n-tasks.yml'
  end

  def configure_smtp
    copy_file 'smtp.rb', 'config/smtp.rb'

    prepend_file 'config/environments/production.rb',
                 %{require Rails.root.join("config/smtp")\n}

    config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
    RUBY

    inject_into_file 'config/environments/production.rb', config,
                     after: 'config.action_mailer.raise_delivery_errors = false'
  end

  def enable_rack_deflater
    config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  config.middleware.use Rack::Deflater
    RUBY

    inject_into_file(
      'config/environments/production.rb',
      config,
      after: serve_static_files_line
    )
  end

  def setup_asset_host
    replace_in_file 'config/environments/production.rb',
                    "# config.action_controller.asset_host = 'http://assets.example.com'",
                    'config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))'

    replace_in_file 'config/initializers/assets.rb',
                    "config.assets.version = '1.0'",
                    'config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")'

    inject_into_file(
      'config/environments/production.rb',
      '  config.static_cache_control = "public, max-age=#{1.year.to_i}"',
      after: serve_static_files_line
    )
  end

  def configure_lograge
    copy_file 'lograge.rb', 'config/initializers/lograge.rb'
  end

  def setup_dalli_cache
    inject_into_file(
      'config/environments/production.rb',
      '  config.cache_store = :dalli_store',
      after: "config.cache_classes = true\n"
    )
  end

  def setup_staging_environment
    staging_file = 'config/environments/staging.rb'
    copy_file 'staging.rb', staging_file

    config = <<~RUBY

                  Rails.application.configure do
                    # ...
                  end
                RUBY

    append_file staging_file, config
  end

  def setup_secret_token
    template 'secrets.yml', 'config/secrets.yml', force: true
  end

  def create_partials_directory
    empty_directory 'app/views/application'
  end

  def create_shared_javascripts
    copy_file '_javascript.html.erb',
              'app/views/application/_javascript.html.erb'
  end

  def create_application_layout
    template 'kratos_layout.html.erb.erb',
             'app/views/layouts/application.html.erb',
             force: true
  end

  def copy_dotfiles
    remove_file '.gitignore'
    directory('dotfiles', '.')
  end

  def configure_action_mailer
    action_mailer_host 'development', %("localhost:3000")
    action_mailer_host 'test', %("www.example.com")
    action_mailer_host 'production', %{ENV.fetch("APPLICATION_HOST")}
  end

  def configure_routes
    remove_file 'config/routes.rb'
    copy_file 'routes.rb', 'config/routes.rb'
  end

  def configure_redis
    copy_file 'redis.rb', 'config/initializers/redis.rb'
  end

  def configure_sidekiq
    copy_file 'sidekiq.yml', 'config/sidekiq.yml'
    copy_file 'sidekiq_rspec.yml', 'spec/support/sidekiq.rb'
    copy_file 'sidekiq_security.rb', 'config/initializers/sidekiq.rb'
    empty_directory 'tmp/pids'

    route = <<-HERE
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
    HERE

    inject_into_file('config/routes.rb',
                     route,
                     after: "Rails.application.routes.draw do\n")
  end

  def configure_time_formats
    remove_file 'config/locales/en.yml'
    copy_file 'config_locales_en_datetime.yml', 'config/locales/en.datetime.yml'
    copy_file 'config_locales_pt-BR_datetime.yml', 'config/locales/pt-BR.datetime.yml'
  end

  def configure_i18n_messages
    template 'config_locales_en_messages.yml.erb', 'config/locales/en.messages.yml'
    template 'config_locales_pt-BR_messages.yml.erb', 'config/locales/pt-BR.messages.yml'
  end

  def configure_whenever
    copy_file 'schedule.rb', 'config/schedule.rb'
  end

  def configure_app_services
    empty_directory 'app/services'

    config = <<-RUBY

  config.autoload_paths += ['#\{config.root}/app/services']
    RUBY

    inject_into_class 'config/application.rb', 'Application', config
  end

  def configure_rubocop
    copy_file 'rubocop.yml', '.rubocop.yml'
    copy_file 'rubocop_database.yml', 'db/migrate/.rubocop.yml'
    copy_file 'rubocop_rspec.yml', 'spec/.rubocop.yml'
  end

  def setup_brazilian_app
    config = <<-RUBY
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = :'pt-BR'
    RUBY

    inject_into_class 'config/application.rb', 'Application', config

    copy_file 'timezones.rb', 'config/initializers/timezones.rb'
  end

  def disable_xml_params
    copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
  end

  def copy_miscellaneous_files
    copy_file 'errors.rb', 'config/initializers/errors.rb'
    copy_file 'json_encoding.rb', 'config/initializers/json_encoding.rb'
  end

  def fix_i18n_deprecation_warning
    config = <<-RUBY
    config.i18n.enforce_available_locales = false
    RUBY

    inject_into_class 'config/application.rb', 'Application', config
  end

  def setup_default_rake_task
    append_file 'Rakefile' do
      <<-EOS
task(:default).clear
task default: [:spec]

if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
end
      EOS
    end
  end

  def configure_puma
    copy_file 'puma.rb', 'config/puma.rb'
  end

  def set_up_forego
    copy_file 'Procfile', 'Procfile'
  end

  def customize_error_pages
    meta_tags = <<-EOS
<meta charset="utf-8" />
<meta name="ROBOTS" content="NOODP" />
<meta name="viewport" content="initial-scale=1" />
    EOS

    %w(500 404 422).each do |page|
      inject_into_file "public/#{page}.html", meta_tags, after: "<head>\n"
      replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
    end
  end

  def remove_config_comment_lines
    config_files = [
      'application.rb',
      'environment.rb',
      'environments/development.rb',
      'environments/production.rb',
      'environments/test.rb'
    ]

    config_files.each do |config_file|
      path = File.join(destination_root, "config/#{config_file}")

      accepted_content = File.readlines(path).reject do |line|
        line =~ /^.*#.*$/ || line =~ /^$\n/
      end

      File.open(path, 'w') do |file|
        accepted_content.each { |line| file.puts line }
      end
    end
  end

  def setup_stylesheets
    remove_file 'app/assets/stylesheets/application.css'
    copy_file 'application.scss',
              'app/assets/stylesheets/application.scss'
  end

  def init_git
    run 'git init'
  end

  def use_postgres_config_template
    template 'postgresql_database.yml.erb', 'config/database.yml',
              force: true
  end

  def create_database
    bundle_command 'exec rake db:create db:migrate'
  end

  def create_capistrano_tasks
    copy_file 'deploy.rake', 'lib/capistrano/tasks/deploy.rake'
    copy_file 'foreman.rake', 'lib/capistrano/tasks/foreman.rake'
  end

  def create_capfile
    copy_file 'Capfile', 'Capfile'
  end

  def create_capistrano_config
    template 'deploy_config.rb.erb', 'config/deploy.rb'
  end

  def create_capistrano_config
    copy_file 'cap_environment.rb', 'config/deploy/production.rb'
    copy_file 'cap_environment.rb', 'config/deploy/staging.rb'
  end

  def setup_bundler_audit
    copy_file 'bundler_audit.rake', 'lib/tasks/bundler_audit.rake'
    append_file 'Rakefile', %(\ntask default: "bundler:audit"\n)
  end

  def setup_rubocop
    copy_file 'rubocop.rake', 'lib/tasks/rubocop.rake'
    append_file 'Rakefile', %(\ntask default: "rubocop"\n)
  end

  def setup_brakeman
    copy_file 'brakeman.rake', 'lib/tasks/brakeman.rake'
    append_file 'Rakefile', %(\ntask default: "brakeman:run"\n)
  end

  private

  def raise_on_missing_translations_in(environment)
    config = 'config.action_view.raise_on_missing_translations = true'

    uncomment_lines("config/environments/#{environment}.rb", config)
  end

  def serve_static_files_line
    "config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?\n"
  end
end

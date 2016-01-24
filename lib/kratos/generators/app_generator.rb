require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Kratos
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, type: :string, aliases: '-d', default: 'postgresql',
                            desc: "Configure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, type: :boolean, aliases: '-T', default: true,
                                  desc: 'Skip Test::Unit files'

    class_option :skip_turbolinks, type: :boolean, default: true,
                                   desc: 'Skip turbolinks gem'

    class_option :skip_bundle, type: :boolean, aliases: '-B', default: true,
                               desc: "Don't run bundle install"

    def finish_template
      invoke :kratos_customization
      super
    end

    def kratos_customization
      invoke :customize_gemfile
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :setup_secret_token
      invoke :create_views
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :setup_git
      invoke :setup_database
      invoke :setup_capistrano
      invoke :setup_quality_control
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used

      bundle_command 'install'
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_missing_assets_in_test
      build :raise_on_delivery_errors
      build :set_test_delivery_method
      build :add_bullet_gem_configuration
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :provide_dev_prime_task
      build :configure_generators
      build :configure_i18n_for_missing_translations
      build :configure_quiet_assets
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :set_up_factory_girl_for_rspec
      build :create_factories_directory
      build :generate_rspec
      build :configure_rspec
      build :enable_database_cleaner
      build :provide_shoulda_matchers_config
      build :configure_spec_support_features
      build :configure_ci
      build :configure_i18n_for_test_environment
      build :configure_action_mailer_in_specs
      build :configure_capybara_poltergeist
      build :configure_rspec_api_documentation
      build :configure_acceptance_helpers
      build :configure_i18n_tasks
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_smtp
      build :enable_rack_deflater
      build :setup_asset_host
      build :configure_lograge
      build :setup_dalli_cache
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def setup_secret_token
      say 'Moving secret token out of version control'
      build :setup_secret_token
    end

    def create_views
      say 'Creating views'
      build :create_partials_directory
      build :create_shared_javascripts
      build :create_application_layout
    end

    def configure_app
      say 'Configuring app'
      build :copy_dotfiles
      build :configure_default_url_options
      build :configure_action_mailer
      build :configure_redis
      build :configure_sidekiq
      build :configure_routes
      build :configure_time_formats
      build :configure_i18n_messages
      build :configure_whenever
      build :configure_app_services
      build :setup_brazilian_app
      build :setup_dalli_store
      build :disable_xml_params
      build :copy_miscellaneous_files
      build :fix_i18n_deprecation_warning
      build :setup_default_rake_task
      build :configure_puma
      build :set_up_forego
      build :customize_error_pages
      build :remove_config_comment_lines
    end

    def setup_stylesheets
      say 'Set up stylesheets'
      build :setup_stylesheets
    end

    def setup_git
      return if options[:skip_git]

      say 'Initializing git'
      build :init_git
    end

    def setup_database
      say 'Setting up database'

      build :use_postgres_config_template if 'postgresql' == options[:database]

      build :create_database
    end

    def setup_capistrano
      say 'Setting up Capistrano'

      build :create_capistrano_tasks
      build :create_capfile
      build :create_capistrano_config
      build :create_capistrano_environments
    end

    def setup_quality_control
      say 'Setting up quality control tools'
      build :setup_bundler_audit
      build :setup_rubocop
      build :setup_brakeman
    end
  end
end

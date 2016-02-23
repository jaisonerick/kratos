namespace :deploy do
  task :restart do
    invoke 'foreman:export'
    invoke 'foreman:restart'
    invoke 'deploy:setup_nginx'
  end

  task :setup_nginx do
    invoke 'nginx:site:add'
    invoke 'nginx:site:enable'
    invoke 'nginx:reload'
  end

  task :setup_env do
    env_file = "env_#{fetch(:stage)}.gpg"

    dotenv_contents = ''
    run_locally do
      fail "You must have a #{env_file} file on your project root " \
           'to be able to deploy it' unless File.exist?(env_file)

      dotenv_contents = `bundle exec dotgpg cat #{env_file}`
    end

    on roles(:app) do
      dotenv = StringIO.new
      dotenv << dotenv_contents
      dotenv.rewind

      upload! dotenv, File.join(shared_path, '.env')
    end
  end
  after :started, :setup_env

  namespace :check do
    task linked_files: '.env'
  end
end

remote_file '.env' => 'deploy:setup_env', roles: :app

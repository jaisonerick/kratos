namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app) do
      within current_path do
        # Create the upstart script
        execute(:sudo, "#{fetch(:rbenv_prefix)} " \
                'foreman export upstart /etc/init ' \
                "-a #{fetch(:application)} " \
                "-u #{fetch(:user)} ")
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles(:app) do
      execute("sudo service #{fetch(:application)} start")
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles(:app) do
      execute("sudo service #{fetch(:application)} stop")
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles(:app), in: :sequence, wait: 15 do
      execute("sudo service #{fetch(:application)} start || " \
              "sudo service #{fetch(:application)} restart")
    end
  end
end

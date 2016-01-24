namespace :deploy do
  task :setup_env do
    on roles(:web) do
      within release_path do
        execute(:cp, "~/.#{fetch(:application)}.yml config/application.yml")
        execute(:cp, "~/.#{fetch(:application)}.env .env")
        execute(:cp, "~/.#{fetch(:application)}.foreman .foreman")
      end
    end
  end
  before :updated, :setup_env

  task :restart do
    invoke 'foreman:export'
    invoke 'foreman:restart'
  end

  desc 'reload the database with seed data'
  task :seed do
    on primary :db do
      within current_path do
        with rails_env: fetch(:stage) do
          execute(:rake, 'db:seed')
        end
      end
    end
  end
end

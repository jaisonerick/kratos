# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
job_type :command, 'dotenv :task :output'
job_type :rake,    'cd :path && dotenv bundle exec rake :task --silent :output'
job_type :runner,  "cd :path && dotenv bin/rails runner -e :environment ':task' :output"
job_type :script,  'cd :path && dotenv bin/:task :output'

# every 1.day, at: '1:00 am' do
# rake ...
# end

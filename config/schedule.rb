# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

#PATH='/usr/local/bin:/usr/bin:/bin:/opt/ruby/bin'

#set :job_template, "bash -l -c PATH=#{PATH} ':job'"
set :output, "/www-data/courses/shared/log/cron_log.log"
e = 'LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8'
job_type :rake,    "cd :path && #{e} RAILS_ENV=:environment bundle exec rake :task --silent :output"

every 1.hour do
  rake "update:news"
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/www-data/courses/shared/log/cron_log.log"

every 2.hours do
  rake "update:news"
end

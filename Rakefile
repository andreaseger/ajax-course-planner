require 'rake'

desc 'setup the environment for the rest of the tasks'
task :environment do
  require './env'
  require 'bundler'

  env = ENV['RACK_ENV'] || 'production'

  Bundler.setup
  Bundler.require(:default, env)

  REDIS_CONFIG =  if ENV['PLANNER_REDIS_URL']
                    require 'uri'
                      uri = URI.parse ENV['PLANNER_REDIS_URL']
                        {
                          host: uri.host,
                          port: uri.port,
                          password: uri.password,
                          db: uri.path.gsub(/^\//, '')
                        }
                  else
                    {}
                  end
  $redis = Redis.new(REDIS_CONFIG)
end

desc 'run the BookingsParser again'
task :update_bookings => ["environment"] do
  require './lib/bookings_parser'
  BookingsParser.run
end

desc 'clear all data from the choosen redis db'
task :clear_db => ["environment"] do
  $redis.flushdb
end

desc 'show some database stats'
task :db_stats => ["environment"] do
  p $redis.info
end
task :default => ["rspec"]

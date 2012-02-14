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

namespace :update do
  desc 'run the BookingsParser'
  task :bookings => ["environment"] do
    require './lib/bookings_parser'
    BookingsParser.run
    print "Bookingsparser finished\n"
  end

  desc 'run the ExamsParser'
  task :exams => ["environment"] do
    require './lib/exams_parser'
    ExamsParser.run
    print "Examsparser finished\n"
  end

  desc 'update both'
  task :both => ['db:flush', 'update:bookings', 'update:exams']
end

namespace :db do
  desc 'clear all data from the choosen redis db'
  task :flush => ["environment"] do
    $redis.flushdb
    print "Database flushed\n"
  end

  desc 'show some database stats'
  task :stats => ["environment"] do
    p $redis.info
  end
end

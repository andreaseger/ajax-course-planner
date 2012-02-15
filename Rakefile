require 'rake'

desc 'setup the environment for the rest of the tasks'
task :environment do
  require_relative 'config/environment'
  $redis = Redis.new(REDIS_CONFIG)
end

namespace :update do
  desc 'run the BookingsParser'
  task :bookings => ["environment", "delete:bookings"] do
    require_relative 'lib/bookings_parser'
    BookingsParser.run
    print "Bookingsparser finished\n".green
  end

  desc 'update both'
  task :both => ['db:flush', 'update:bookings', 'update:exams']

  #desc 'run the ExamsParser'
  #task :exams => ["environment"] do
  #  require_relative 'lib/exams_parser'
  #  ExamsParser.run
  #  print "Examsparser finished\n".green
  #end
end

namespace :delete do
  desc 'delete all bookings'
  task :bookings => ["environment"] do
    require_relative 'lib/booking'
    print "#{Booking.delete_all} Items deleted\n".yellow
  end
  #desc 'delete all exams'
  #task :exams => ["environment"] do
  #  require_relative 'lib/exam'
  #  Exam.delete_all
  #end
end
namespace :db do
  desc 'clear all data from the choosen redis db'
  task :flush => ["environment"] do
    $redis.flushdb
    print "Database flushed\n".yellow
  end

  desc 'show some database stats'
  task :stats => ["environment"] do
    ap $redis.info
  end
  desc 'rebuild database'
  task :rebuild => ['db:flush', 'update:bookings']
end

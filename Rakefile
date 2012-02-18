$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
require 'rake'

desc 'setup the environment for the rest of the tasks'
task :environment do
  require 'environment'
  $redis = Redis.new(REDIS_CONFIG)
end

namespace :update do
  desc 'run the BookingsParser'
  task :bookings => ["environment", "delete:bookings"] do
    require 'bookings_parser'
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
    require 'booking'
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

namespace :assets do
  desc 'compile assets'
  task :compile => [:compile_js, :compile_css] do
  end

  desc 'compile javascript assets'
  task :compile_js => ['environment'] do
    asset     = sprockets['application.js']
    outpath   = File.join(root, 'public', 'compiled', 'js')
    outfile   = Pathname.new(outpath).join('application.min.js') # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled js assets"
  end

  desc 'compile css assets'
  task :compile_css => ['environment'] do
    asset     = sprockets['application.css']
    outpath   = File.join(root, 'public', 'compiled', 'css')
    outfile   = Pathname.new(outpath).join('application.min.css') # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled css assets"
  end

  desc 'copy images'
  task :copy_images => ['environment'] do
    #TODO
  end

  desc 'delete compiled assets'
  task :clean_all do
    FileUtils.rm_rf File.join(root, 'public', 'compiled')
  end
  desc 'delete compiled css'
  task :clean_css do
    FileUtils.rm_rf File.join(root, 'public', 'compiled', 'css')
  end
  desc 'delete compiled js'
  task :clean_js do
    FileUtils.rm_rf File.join(root, 'public', 'compiled', 'js')
  end
  # todo: add :clean_all, :clean_css, :clean_js tasks, invoke before writing new file(s)
end
def root
  File.dirname(__FILE__)
end

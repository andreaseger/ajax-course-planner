$:.unshift File.expand_path("../config",__FILE__)
$:.unshift File.expand_path("../lib",__FILE__)
require 'rake'

desc 'setup the environment for the rest of the tasks'
task :environment do
  p Time.now
  require 'environment'
  require "assets"
  $redis = Redis.new(REDIS_CONFIG)
end

namespace :update do
  desc 'run the BookingsParser'
  task :bookings => ["environment", "delete:bookings"] do
    require 'bookings_parser'
    BookingsParser.run
    print "Bookingsparser finished\n".green
  end

  desc 'update all'
  task :all => ['db:flush', 'update:bookings', 'update:news']

  desc 'run the NewsParser'
  task :news => ["environment", "delete:news"] do
    require 'news_parser'
    NewsParser.run
    print "Newsparser finished\n".green
  end
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
    c = Booking.delete_all
    print "#{c} Items deleted\n".yellow if c > 0
  end

  desc 'delete all news'
  task :news => ["environment"] do
    require 'news'
    c = News.delete_all
    print "#{c} Items deleted\n".yellow if c > 0
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
  task :rebuild => ['db:flush', 'update:all']
end

namespace :assets do
  desc 'compile assets'
  task :compile => [:compile_js, :compile_css] do
  end

  desc 'compile javascript assets'
  task :compile_js => ['environment', 'assets:clean_js'] do
    require 'uglifier'
    s = sprockets
    s.js_compressor = Uglifier.new(mangle: true)
    asset     = s['application.js']
    outpath   = File.join(root, 'public', 'assets')
    outfile   = Pathname.new(outpath).join('application.min.js') # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled js assets"
  end

  desc 'compile css assets'
  task :compile_css => ['environment', 'assets:clean_css'] do
    require 'yui/compressor'
    s = sprockets
    s.css_compressor = YUI::CssCompressor.new
    asset     = s['application.css']
    outpath   = File.join(root, 'public', 'assets')
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

  desc "create template.json"
  task :create_templates do
    require 'json'
    File.open(File.join(root, 'public', 'templates.json'), 'w') do |f|
      f.print Dir['templates/client/*'].map {|e| { name: File.basename(e, '.mustache').sub(/^_/,''), template: IO.read(e) } }.to_json
    end
  end
end
def root
  File.dirname(__FILE__)
end
def sprockets
  Assets.sprockets
end

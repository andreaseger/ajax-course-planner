%w(booking exam news structure_helper assets assets_helper template_helper).each do |lib|
  require_relative "lib/#{lib}"
end
require 'set'

class CoursePlanner < Sinatra::Base
  register Mustache::Sinatra
  register Sinatra::Namespace
  require_relative 'views/site.rb'
  helpers Sinatra::StructureHelper
  helpers Sinatra::TemplateHelper

  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')

  configure do |c|
    set :mustache, {
      templates: File.join(root, 'templates'),
      views: File.join(root, 'views'),
      namespace: CoursePlanner
    }
    disable :exams
    $redis = Redis.new(REDIS_CONFIG)
    puts "redis: #{REDIS_CONFIG}"
  end

  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.tb"
  end

  get '/' do
    redirect url('bookings/g/ig')
  end

  get '/templates.json' do
    json templates
  end
  get '/assets/*' do
    new_env = env.clone
    new_env["PATH_INFO"].gsub!('/assets','')
    ::Assets.sprockets.call(new_env)
  end

  namespace '/api' do
    get '/s' do
      bookings = params[:bookings]
      get_exams = params[:exams]
      structure = params[:structure].try(:to_sym) || :list
      if bookings
        b = bookings.map { |e| Booking.find(e) }.compact.map{|b| b.merge(key: b.key)}
        perm = "/schedule/#{b.map{|e| e[:key]}.join('/')}"
        schedule= build_schedule(b,structure)
        if get_exams && settings.exams
          exams = schedule.map { |e| Exam.find_by_course(e[:course][:name]) }.flatten.compact
          json( bookings: schedule, has_exams: !exams.empty?, exams: exams, permalink: perm )
        else
          json( bookings: schedule, has_exams: false, permalink: perm, keys: b.map{|e| e[:key]}  )
        end
      end
    end

    get '/b/g' do
      group = params[:group]
      structure = params[:structure].try(:to_sym) || :list
      b = Booking.find_by_group(group).map{|b| b.merge(key: b.key)}
      json( build_schedule(b, structure) )
    end

    get '/g' do
      json( groups: $redis.smembers('groups').sort )
    end

    #get '/e' do
    #  courses = params[:courses]
    #  if courses
    #    json courses.map {|e| Exam.find_by_course(e) }
    #  end
    #end
    get '/n' do
      bookings = params[:bookings]
      if bookings
        people = Set.new(bookings.map { |e| Booking.find(e) }.compact.map{|b| b.merge(key: b.key)}.map{|e| [ e[:people], e[:teacher] ] }.flatten)
        people_codes = people.map{|e| e[:name] }
        news = build_newslist( News.find_by_people( people_codes ) )
        json( news: news, people: people.to_a )
      end
    end
  end

  get '/fluid' do
    @settings = settings
    mustache :fluid, layout: false
  end
  get '/schedule/*' do
    @pagename = 'schedule'
    @settings = settings
    mustache :site, layout: false
  end
  get '/bookings/g/:group' do
    @settings = settings
    mustache :site, layout: false
  end
end

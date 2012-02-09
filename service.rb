require_relative 'lib/booking'
require_relative 'lib/exam'
require_relative 'lib/helper'

class CoursePlanner < Sinatra::Base
  configure do |c|
    register Sinatra::Contrib
    register Sinatra::Flash
    register Mustache::Sinatra
    helpers Sinatra::MyHelper

    set :mustache, {
      templates: File.dirname(__FILE__) + '/templates',
      views: File.dirname(__FILE__) + '/views',
      namespace: CoursePlanner
    }
    disable :exams

    set :public_folder, File.dirname(__FILE__) + '/public'
    enable :sessions
    $redis = Redis.new(REDIS_CONFIG)
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
          json( bookings: schedule, has_exams: false, permalink: perm )
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
      json( groups: $redis.smembers('group').sort )
    end

    get '/e' do
      courses = params[:courses]
      if courses
        json courses.map {|e| Exam.find_by_course(e) }
      end
    end
  end

  get '/schedule/*' do
    mustache :site, :layout => false
  end
  get '/bookings/g/:group' do
    mustache :site, :layout => false
  end
end
